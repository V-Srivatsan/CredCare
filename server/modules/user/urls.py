from fastapi import APIRouter, Depends, HTTPException
from . import logic, forms, models
from middleware import auth as middleware

router = APIRouter(prefix='/user')

@router.post('/register')
async def register_user(data: forms.UserRegister):
    return await logic.create_user(data)

@router.post('/login')
async def login_user(data: forms.UserLogin):
    return await logic.login_user(data)

@router.post('/verify-otp')
async def verify_otp(data: forms.UserOTP):
    return await logic.verify_otp(data)

@router.get('/')
async def get_profile(uid: str = Depends(middleware.get_user)):
    return await logic.get_profile(uid)