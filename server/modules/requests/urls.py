from fastapi import APIRouter, Depends
router = APIRouter(prefix='/requests')

from middleware import auth as middleware
from . import logic, forms

@router.get('/')
async def get_requests(user: str = Depends(middleware.get_verified_user)):
    return await logic.get_requests(user)

@router.post('/')
async def create_request(form: forms.CreateRequest, user: str = Depends(middleware.get_verified_user)):
    return await logic.create_request(form, user)

@router.delete('/{request_id}')
async def delete_request(request_id: str, user: str = Depends(middleware.get_verified_user)):
    return await logic.cancel_request(request_id, user)

@router.put('/accept/{request_id}')
async def accept_request(request_id: str, user: str = Depends(middleware.get_verified_user)):
    return await logic.accept_request(request_id, user)

@router.delete('/accept/{request_id}')
async def opt_out(request_id: str, user: str = Depends(middleware.get_verified_user)):
    return await logic.opt_out(request_id, user)

@router.put('/complete/{request_id}')
async def complete_request(
    request_id: str, data: forms.CompleteRequest,
    user: str = Depends(middleware.get_verified_user)
):
    return await logic.complete_request(request_id, user, data.points)