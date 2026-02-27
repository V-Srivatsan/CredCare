from .models import User
from . import forms
from fastapi import HTTPException
from lib.cache import cache

import random, os, jwt
from string import digits
from datetime import datetime, timedelta, timezone
from typing import Optional

async def create_access_token(user: User, expires_delta: Optional[timedelta] = None):
    expire = datetime.now(timezone.utc) + (
        expires_delta if expires_delta 
        else timedelta(minutes=15)
    )

    return jwt.encode({
        "uid": str(user.uid.hex),
        "is_head": user.membership.is_head if user.membership else False,
        "is_verified": user.is_verified,
        # "exp": expire
    }, os.environ["SECRET_KEY"], algorithm=os.environ["ALGORITHM"])


async def create_user(data: forms.UserRegister):
    if await User.filter(phone=data.phone).exists():
        raise HTTPException(status_code=400, detail={"message": "User with this phone already exists"})
    
    await User.create(name=data.name, phone=data.phone)
    return { "message": "User created successfully" }

async def login_user(data: forms.UserLogin):
    user = await User.get_or_none(phone=data.phone)
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    otp = ''.join(random.choices(digits, k=6))
    cache.set(data.phone, otp, ttl=300)
    
    return { "otp": otp }

async def verify_otp(data: forms.UserOTP):
    cached_otp = cache.get(data.phone)
    if not cached_otp:
        raise HTTPException(status_code=400, detail={"message": "OTP expired or not found"})
    
    if cached_otp.decode() != data.otp:
        raise HTTPException(status_code=400, detail={"message": "Invalid OTP"})
    
    user = await User.get_or_none(phone=data.phone).prefetch_related('membership')
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    cache.delete(data.phone)
    return {
        "token": await create_access_token(user),
    }

async def get_profile(uid: str):
    user = await User.get_or_none(uid=uid).prefetch_related('membership')
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    return {
        "name": user.name,
        "score": user.score,
        "is_head": user.membership.is_head if user.membership else False,
        "is_verified": user.is_verified,
    }