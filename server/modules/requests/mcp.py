from fastapi import APIRouter, Depends
router = APIRouter(prefix='/requests')

from middleware import auth as middleware
from middleware.mcp import Auth
from . import logic, forms

class CreateRequest(forms.CreateRequest, Auth): pass

@router.post('/', operation_id="credcare_get_requests")
async def get_requests(data: Auth):
    user = await middleware.get_verified_user(data.access_token)
    return await logic.get_requests(user)

@router.post('/created', operation_id="credcare_get_created_requests")
async def get_created_requests(data: Auth):
    user = await middleware.get_verified_user(data.access_token)
    return await logic.get_created_requests(user)

@router.post('/accepted', operation_id="credcare_get_accepted_requests")
async def get_accepted_requests(data: Auth):
    user = await middleware.get_verified_user(data.access_token)
    return await logic.get_accepted_requests(user)

@router.post('/create', operation_id="credcare_create_request")
async def create_request(form: CreateRequest):
    user = await middleware.get_verified_user(form.access_token)
    return await logic.create_request(form, user)

@router.post('/cancel/{request_id}', operation_id="credcare_cancel_request")
async def cancel_request(request_id: str, data: Auth):
    user = await middleware.get_verified_user(data.access_token)
    return await logic.cancel_request(request_id, user)

@router.post('/accept/{request_id}', operation_id="credcare_accept_request")
async def accept_request(request_id: str, data: Auth):
    user = await middleware.get_verified_user(data.access_token)
    return await logic.accept_request(request_id, user)

@router.post('/opt-out/{request_id}', operation_id="credcare_opt_out")
async def opt_out(request_id: str, data: Auth):
    user = await middleware.get_verified_user(data.access_token)
    return await logic.opt_out(request_id, user)

@router.post('/complete/{request_id}', operation_id="credcare_complete_request")
async def complete_request(request_id: str, data: Auth):
    user = await middleware.get_verified_user(data.access_token)
    return await logic.complete_request(request_id, user)