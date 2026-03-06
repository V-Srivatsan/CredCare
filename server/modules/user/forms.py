from pydantic import BaseModel

class UserRegister(BaseModel):
    name: str
    phone: str

class UserLogin(BaseModel):
    phone: str

class UserOTP(BaseModel):
    phone: str
    otp: str