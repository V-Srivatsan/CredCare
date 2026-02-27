from fastapi import HTTPException
from . import models, forms
from tortoise.expressions import Q

from modules.user import models as user_models, service as user_service



async def get_requests(uid: str):
    user = await user_models.User.get(uid=uid).prefetch_related('membership__community')
    
    if not user.membership:
        raise HTTPException(status_code=404, detail="User does not belong to any community")
    
    requests = await models.Request.filter(
        community=user.membership.community,
        status=models.RequestStatus.PENDING
    ).prefetch_related('creator')

    return {
        "requests": [
            {
                "uid": request.uid.hex,
                "user": request.creator.name,
                "title": request.title,
                "description": request.description,    
                "updated_at": request.updated_at.isoformat()        
            } for request in requests
        ]
    }

async def create_request(data: forms.CreateRequest, uid: str):
    user = await user_models.User.get(uid=uid).prefetch_related('membership__community')

    if not user.membership:
        raise HTTPException(status_code=404, detail="User does not belong to any community")
    
    await models.Request.create(
        creator=user,
        community=user.membership.community,
        title=data.title,
        description=data.description
    )

    return { "message": "Request created successfully" }

async def cancel_request(request_uid: str, uid: str):
    user = await user_models.User.get(uid=uid)
    updated = await models.Request.filter(
        uid=request_uid, creator=user, 
        status=models.RequestStatus.PENDING
    ).update(status=models.RequestStatus.CANCELLED)

    if updated:
        return { "message": "Request cancelled successfully" }
    
    request = await models.Request.get_or_none(uid=request_uid)
    if not request:
        raise HTTPException(status_code=404, detail={"message": "Request not found"})
    
    if request.creator_id != user.pk:
        raise HTTPException(status_code=403, detail={"message": "Only the creator can cancel the request"})

    if not request.status.can_transition_to(models.RequestStatus.CANCELLED):
        raise HTTPException(status_code=409, detail={"message": f"Request cannot be cancelled in its current state"})

    raise HTTPException(status_code=400, detail={"message": "Could not cancel request"})

async def accept_request(request_uid: str, uid: str):
    user = await user_models.User.get(uid=uid)
    updated = await models.Request.filter(
        ~Q(creator=user),
        uid=request_uid,
        status=models.RequestStatus.PENDING
    ).update(status=models.RequestStatus.ACCEPTED, acceptor=user)

    if updated:
        return { "message": "Request accepted successfully" }
    
    request = await models.Request.get_or_none(uid=request_uid)
    if not request:
        raise HTTPException(status_code=404, detail={"message": "Request not found"})
    
    if request.creator.pk == user.pk:
        raise HTTPException(status_code=403, detail={"message": "Cannot accept your own request"})

    if not request.status.can_transition_to(models.RequestStatus.ACCEPTED):
        raise HTTPException(status_code=409, detail={"message": f"Request cannot be accepted in its current state"})
    
    raise HTTPException(status_code=400, detail={"message": "Could not accept request"})

async def opt_out(request_uid: str, uid: str):
    user = await user_models.User.get(uid=uid)
    updated = await models.Request.filter(
        uid=request_uid,
        status=models.RequestStatus.ACCEPTED,
        acceptor=user
    ).update(status=models.RequestStatus.PENDING, acceptor_id=None)

    if updated:
        return { "message": "Opted out of request successfully" }
    
    request = await models.Request.get_or_none(uid=request_uid).prefetch_related('acceptor')
    if not request:
        raise HTTPException(status_code=404, detail={"message": "Request not found"})
    
    if request.acceptor.pk != user.pk:
        raise HTTPException(status_code=403, detail={"message": "Only the acceptor can opt out of the request"})
    
    if not request.status.can_transition_to(models.RequestStatus.PENDING):
        raise HTTPException(status_code=409, detail={"message": "Only uncompleted accepted requests can be opted out of"})
    
    raise HTTPException(status_code=400, detail={"message": "Could not opt out of request"})

async def complete_request(request_uid: str, user_uid: str, points: int):
    user = await user_models.User.get(uid=user_uid)
    updated = await models.Request.filter(
        uid=request_uid,
        status=models.RequestStatus.ACCEPTED,
        creator=user
    ).update(status=models.RequestStatus.COMPLETED)

    if updated:
        await user_service.update_points(user.pk, points)
        return { "message": "Request completed successfully" }
    
    request = await models.Request.get_or_none(uid=request_uid).prefetch_related('creator', 'acceptor')
    if not request:
        raise HTTPException(status_code=404, detail={"message": "Request not found"})
    
    if user.pk != request.creator_id:
        raise HTTPException(status_code=403, detail={"message": "Only the creator can complete the request"})
    
    if not request.status.can_transition_to(models.RequestStatus.COMPLETED):
        raise HTTPException(status_code=409, detail={"message": "Only accepted requests can be completed"})
    
    raise HTTPException(status_code=400, detail={"message": "Could not complete request"})