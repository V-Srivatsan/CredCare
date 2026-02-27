from fastapi import HTTPException
from . import models, forms

from modules.user import models as user_models, service as user_service

async def get_requests(uid: str):
    user = await user_models.User.get_or_none(uid=uid).prefetch_related('membership__community')
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
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
    user = await user_models.User.get_or_none(uid=uid).prefetch_related('membership__community')
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
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
    user = await user_models.User.get_or_none(uid=uid)
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    request = await models.Request.get_or_none(uid=request_uid, creator=user)
    if not request:
        raise HTTPException(status_code=403, detail={"message": "Only the creator can cancel the request"})
    
    updated = await models.Request.filter(
        uid=request_uid, creator=user, 
        status=models.RequestStatus.PENDING
    ).update(status=models.RequestStatus.CANCELLED)

    if not updated:
        raise HTTPException(status_code=409, detail={"message": "Could not cancel request. It is possible that someone accepted your request"})

    return { "message": "Request cancelled successfully" }

async def accept_request(request_uid: str, uid: str):
    user = await user_models.User.get_or_none(uid=uid)
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    request = await models.Request.get_or_none(uid=request_uid).prefetch_related('creator')
    if not request:
        raise HTTPException(status_code=404, detail={"message": "Request not found"})
    
    if request.creator.pk == user.pk:
        raise HTTPException(status_code=403, detail={"message": "Cannot accept your own request"})
    
    updated = await models.Request.filter(
        uid=request_uid,
        status=models.RequestStatus.PENDING
    ).update(status=models.RequestStatus.ACCEPTED, acceptor=user)

    if not updated:
        raise HTTPException(status_code=409, detail={"message": "Could not accept request. It is possible someone else accepted the request or it was cancelled"})
    
    return { "message": "Request accepted successfully" }

async def opt_out(request_uid: str, uid: str):
    user = await user_models.User.get_or_none(uid=uid)
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    request = await models.Request.get_or_none(uid=request_uid).prefetch_related('acceptor')
    if not request:
        raise HTTPException(status_code=404, detail={"message": "Request not found"})
    
    if request.status != models.RequestStatus.ACCEPTED or not request.acceptor:
        raise HTTPException(status_code=409, detail={"message": "Only uncompleted accepted requests can be opted out of"})
    
    if request.acceptor.pk != user.pk:
        raise HTTPException(status_code=403, detail={"message": "Only the acceptor can opt out of the request"})
    
    
    updated = await models.Request.filter(
        uid=request_uid,
        status=models.RequestStatus.ACCEPTED,
        acceptor=user
    ).update(status=models.RequestStatus.PENDING, acceptor_id=None)

    if not updated:
        raise HTTPException(status_code=409, detail={"message": "Could not opt out of request. It is possible the request was completed"})

    return { "message": "Opted out of request successfully" }

async def complete_request(request_uid: str, user_uid: str, points: int):
    user = await user_models.User.get_or_none(uid=user_uid)
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    request = await models.Request.get_or_none(uid=request_uid).prefetch_related('creator', 'acceptor')
    if not request:
        raise HTTPException(status_code=404, detail={"message": "Request not found"})
    if user.pk != request.creator.pk:
        raise HTTPException(status_code=403, detail={"message": "Only the creator can complete the request"})
    
    if request.status != models.RequestStatus.ACCEPTED:
        raise HTTPException(status_code=409, detail={"message": "Only accepted requests can be completed"})
    
    updated = await models.Request.filter(
        uid=request_uid,
        status=models.RequestStatus.ACCEPTED,
        creator=user
    ).update(status=models.RequestStatus.COMPLETED)

    if not updated:
        raise HTTPException(status_code=409, detail={"message": "Could not complete request. It is possible the acceptor opted out"})
    
    await user_service.update_points(request.acceptor.pk, points)

    return { "message": "Request completed successfully" }