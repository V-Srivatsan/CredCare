from tortoise import migrations
from tortoise.migrations import operations as ops
from modules.requests.models import RequestStatus
from tortoise.fields.base import OnDelete
from uuid import uuid4
from tortoise import fields

class Migration(migrations.Migration):
    initial = True

    operations = [
        ops.CreateModel(
            name='Request',
            fields=[
                ('id', fields.IntField(generated=True, primary_key=True, unique=True, db_index=True)),
                ('uid', fields.UUIDField(default=uuid4, unique=True)),
                ('created_at', fields.DatetimeField(auto_now=False, auto_now_add=True)),
                ('updated_at', fields.DatetimeField(auto_now=True, auto_now_add=False)),
                ('creator', fields.ForeignKeyField('user.User', source_field='creator_id', null=True, db_constraint=True, to_field='id', related_name='created_requests', on_delete=OnDelete.SET_NULL)),
                ('acceptor', fields.ForeignKeyField('user.User', source_field='acceptor_id', null=True, db_constraint=True, to_field='id', related_name='accepted_requests', on_delete=OnDelete.SET_NULL)),
                ('community', fields.ForeignKeyField('community.Community', source_field='community_id', db_constraint=True, to_field='id', on_delete=OnDelete.CASCADE)),
                ('title', fields.CharField(max_length=100)),
                ('description', fields.TextField(unique=False)),
                ('status', fields.CharEnumField(default=RequestStatus.PENDING, description='PENDING: PENDING\nACCEPTED: ACCEPTED\nCOMPLETED: COMPLETED\nCANCELLED: CANCELLED', enum_type=RequestStatus, max_length=9)),
            ],
            options={'table': 'request', 'app': 'request', 'pk_attr': 'id'},
            bases=['BaseModel'],
        ),
    ]
