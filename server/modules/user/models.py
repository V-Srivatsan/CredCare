from lib.db import BaseModel
from tortoise import fields

class User(BaseModel):
    name = fields.CharField(max_length=100)
    phone = fields.CharField(max_length=20, unique=True)
    score = fields.IntField(default=0)
    is_verified = fields.BooleanField(default=False)

    def __str__(self):
        return f"User {self.name} (UID: {self.uid})"
    
