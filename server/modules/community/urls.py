from fastapi import APIRouter, Depends
router = APIRouter(prefix='/community')

from middleware import auth as middleware
from . import forms, logic

@router.post('/')
async def create_community(data: forms.CreateCommunity, uid: str = Depends(middleware.get_user)):
    return await logic.create_community(data=data, uid=uid)

@router.post('/join/{community_uid}')
async def join_community(community_uid: str, uid: str = Depends(middleware.get_user)):
    return await logic.join_community(community_uid=community_uid, uid=uid)

@router.put('/verify/{membership_id}')
async def verify_user(membership_id: str, head: str = Depends(middleware.get_head_user)): 
    return await logic.verify_user(membership_id, head)

@router.delete('/leave/')
async def leave_community(uid: str = Depends(middleware.get_user)):
    return await logic.leave_community(uid)