from . import forms, models
from fastapi import HTTPException
from tortoise.transactions import in_transaction
from modules.user import service as user_service, models as user_models
import random

async def create_community(data: forms.CreateCommunity, uid: str):
    user = await user_models.User.get_or_none(uid=uid).prefetch_related('membership')
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    if user.membership:
        raise HTTPException(status_code=400, detail={"message": "User is already part of a community"})

    community = await models.Community.create(name=data.name)
    await models.Membership.create(user=user, community=community, is_head=True)
    await user_service.verify_user(pk=user.pk)

    return { "message": "Community created successfully" }


async def join_community(community_uid: str, uid: str):
    community = await models.Community.get_or_none(uid=community_uid)
    if not community:
        raise HTTPException(status_code=404, detail={"message": "Community not found"})
    
    user = await user_models.User.get_or_none(uid=uid).prefetch_related('membership')
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    if user.membership:
        raise HTTPException(status_code=400, detail={"message": "User already present in another community"})
    
    await models.Membership.create(user=user, community=community)
    await user_service.unverify_user(pk=user.pk)

    community.member_count += 1
    await community.save()

    return { "message": "Joined community successfully" }


async def verify_user(membership_id: str, head_uid: str):
    membership = await models.Membership.get_or_none(uid=membership_id)
    if not membership:
        raise HTTPException(status_code=404, detail={"message": "Membership not found"})
    
    head = await user_models.User.get_or_none(uid=head_uid).prefetch_related('membership')
    if not head:
        raise HTTPException(status_code=404, detail={"message": "Head user not found"})
    
    if not head.membership or not head.membership.is_head:
        raise HTTPException(status_code=403, detail={"message": "Not a community head"})
    
    if head.membership.community_id != membership.community_id:
        raise HTTPException(status_code=403, detail={"message": "Cannot verify someone in another community"})

    await user_service.verify_user(pk=membership.user_id)
    return { "message": "User verified successfully" }


async def leave_community(uid: str):
    user = await user_models.User.get_or_none(uid=uid).prefetch_related('membership')
    if not user:
        raise HTTPException(status_code=404, detail={"message": "User not found"})
    
    if not user.membership:
        raise HTTPException(status_code=404, detail={"message": "User does not belong to any community"})
    
    community = await user.membership.community
    was_head = user.membership.is_head
    await user.membership.delete()

    if (community.member_count > 1): 
        community.member_count -= 1
        await community.save()
        if was_head:
            members = await models.Membership.filter(community=community, is_head=False)
            new_head = random.choice(members)
            new_head.is_head = True
            await new_head.save()

    else: await community.delete()
    await user_service.unverify_user(pk=user.pk)

    return { "message": "Community left successfully" }