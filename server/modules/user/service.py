from fastapi import HTTPException
from . import models
from tortoise.expressions import F

async def verify_user(pk: int):
    user = await models.User.get_or_none(pk=pk)
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    user.is_verified = True
    await user.save()
    
    return {"message": "User verified successfully"}

async def unverify_user(pk: int):
    user = await models.User.get_or_none(pk=pk)
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    user.is_verified = False
    await user.save()
    
    return {"message": "User unverified successfully"}

async def update_points(pk: int, points: int):
    updated = await models.User.filter(pk=pk).update(score=F("score") + points)
    if not updated: raise HTTPException(status_code=404, detail={ "message": "User not found" })
    return { "message": "Score updated successfully" }