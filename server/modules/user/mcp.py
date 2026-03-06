from . import forms, logic
from fastapi import APIRouter, Depends
from middleware import auth as middleware
from middleware.mcp import Auth

router = APIRouter(prefix='/user')

class UserRegister(forms.UserRegister): pass
class UserLogin(forms.UserLogin): pass
class UserOTP(forms.UserOTP): pass
class UserProfile(Auth): pass

@router.post('/register', operation_id="credcare_register")
async def register_user(data: forms.UserRegister):
    return await logic.create_user(data)

@router.post('/login', operation_id="credcare_login")
async def login_user(data: forms.UserLogin):
    return await logic.login_user(data)

@router.post('/verify-otp', operation_id="credcare_verify_otp")
async def verify_otp(data: forms.UserOTP):
    return await logic.verify_otp(data)

@router.post('/', operation_id="credcare_get_profile")
async def get_profile(data: Auth):
    uid = await middleware.get_user(data.access_token)
    return await logic.get_profile(uid)