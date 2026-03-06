import os
import uuid
from tortoise import Model, fields

TORTOISE_ORM = {
    "connections": {
        "default": os.getenv("DB_URL")
    },

    "apps": {
        "user": {
            "models": ["modules.user.models"],
            "default_connection": "default",
            "migrations": "modules.user.migrations"
        },
        "community": {
            "models": ["modules.community.models"],
            "default_connection": "default",
            "migrations": "modules.community.migrations"
        },
        "request": {
            "models": ["modules.requests.models"],
            "default_connection": "default",
            "migrations": "modules.requests.migrations"
        }
    }
}

class BaseModel(Model):
    uid = fields.UUIDField(default=uuid.uuid4, unique=True)
    created_at = fields.DatetimeField(auto_now_add=True)
    updated_at = fields.DatetimeField(auto_now=True)

    class Meta:
        abstract = True