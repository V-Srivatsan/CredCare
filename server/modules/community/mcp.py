from fastapi import APIRouter, Depends
router = APIRouter(prefix='/community')

from middleware import auth as middleware
from middleware.mcp import Auth
from . import forms, logic

class CreateCommunity(forms.CreateCommunity, Auth): pass

@router.post('/', operation_id="credcare_get_communities")
async def get_communities():
    return await logic.get_communities()

@router.post('/create', operation_id="credcare_create_community")
async def create_community(data: CreateCommunity):
    uid = await middleware.get_user(data.access_token)
    return await logic.create_community(data=data, uid=uid)

@router.post('/join/{community_uid}', operation_id="credcare_join_community")
async def join_community(community_uid: str, data: Auth):
    uid = await middleware.get_user(data.access_token)
    return await logic.join_community(community_uid=community_uid, uid=uid)

@router.post('/leave', operation_id="credcare_leave_community")
async def leave_community(data: Auth):
    uid = await middleware.get_user(data.access_token)
    return await logic.leave_community(uid)