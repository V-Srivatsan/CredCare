from fastapi import FastAPI
from tortoise.contrib.fastapi import register_tortoise

app = FastAPI()

from lib.db import TORTOISE_ORM
register_tortoise(
    app=app,
    config=TORTOISE_ORM,
    generate_schemas=False,
)

from modules.user.urls import router as user_router
app.include_router(user_router)

from modules.community.urls import router as community_router
app.include_router(community_router)

from modules.requests.urls import router as requests_router
app.include_router(requests_router)