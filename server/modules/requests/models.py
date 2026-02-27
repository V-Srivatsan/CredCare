from lib.db import BaseModel
from tortoise import fields
from enum import Enum

class RequestStatus(str, Enum):
    PENDING = "PENDING"
    ACCEPTED = "ACCEPTED"
    COMPLETED = "COMPLETED"
    CANCELLED = "CANCELLED"

    __ALLOWED_TRANSITIONS__ = {
        PENDING: [ACCEPTED, CANCELLED],
        ACCEPTED: [COMPLETED, PENDING],
        COMPLETED: [],
        CANCELLED: []
    }

    def can_transition_to(self, new_status):
        return new_status in self.__ALLOWED_TRANSITIONS__.get(self, [])

class Request(BaseModel):
    creator = fields.ForeignKeyField('user.User', on_delete=fields.SET_NULL, null=True, related_name='created_requests')
    acceptor = fields.ForeignKeyField('user.User', on_delete=fields.SET_NULL, null=True, related_name='accepted_requests')
    community = fields.ForeignKeyField('community.Community', on_delete=fields.CASCADE)
    title = fields.CharField(max_length=100)
    description = fields.TextField()
    status = fields.CharEnumField(RequestStatus, default=RequestStatus.PENDING)

    def __str__(self):
        return f"Request {self.uid} by User {self.creator} with status {self.status}"