from lib.db import BaseModel
from tortoise import fields

class Community(BaseModel):
    name = fields.CharField(max_length=100)
    member_count = fields.IntField(default=1)

    @property
    def is_verified(self): return self.member_count >= 25

    def __str__(self):
        return f"Community {self.name} (UID: {self.uid})"
    

class Membership(BaseModel):
    user = fields.OneToOneField('user.User', on_delete=fields.CASCADE, related_name='membership')
    community = fields.ForeignKeyField('community.Community', on_delete=fields.CASCADE)
    is_head = fields.BooleanField(default=False)