import jwt
import os

from fastapi import Depends, HTTPException
from fastapi.security import OAuth2PasswordBearer

# Configuration
SECRET_KEY = os.environ["SECRET_KEY"]
ALGORITHM = os.environ["ALGORITHM"]

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")


def verify_token(token: str):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        uid: str | None = payload.get("uid")
        if uid is None:
            raise HTTPException(
                status_code=401,
                detail={"message": "Could not validate credentials"},
                headers={"WWW-Authenticate": "Bearer"},
            )
        return payload
    except jwt.ExpiredSignatureError:
        raise HTTPException(
            status_code=401,
            detail={"message": "Token has expired"},
            headers={"WWW-Authenticate": "Bearer"},
        )
    except jwt.PyJWTError:
        raise HTTPException(
            status_code=401,
            detail={"message": "Could not validate credentials"},
            headers={"WWW-Authenticate": "Bearer"},
        )

async def get_user(token: str = Depends(oauth2_scheme)):
    return verify_token(token)["uid"]

async def get_verified_user(token: str = Depends(oauth2_scheme)):
    payload = verify_token(token)
    if not payload.get("is_verified", False):
        raise HTTPException(status_code=403, detail={"message": "User is not verified"})
    return payload["uid"]

async def get_head_user(token: str = Depends(oauth2_scheme)):
    payload = verify_token(token)
    await get_verified_user(token)
    if not payload.get("is_head", False):
        raise HTTPException(status_code=403, detail={"message": "User is not a head"})
    return payload["uid"]
