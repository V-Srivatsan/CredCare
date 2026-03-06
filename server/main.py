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



from fastapi_mcp import FastApiMCP
mcp_app = FastAPI()

from modules.user.mcp import router as user_mcp_router
mcp_app.include_router(user_mcp_router)

from modules.community.mcp import router as community_mcp_router
mcp_app.include_router(community_mcp_router)

from modules.requests.mcp import router as requests_mcp_router
mcp_app.include_router(requests_mcp_router)

mcp = FastApiMCP(mcp_app)
mcp.mount_http(app)