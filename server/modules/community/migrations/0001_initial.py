from tortoise import migrations
from tortoise.migrations import operations as ops
from tortoise.fields.base import OnDelete
from uuid import uuid4
from tortoise import fields

class Migration(migrations.Migration):
    initial = True

    operations = [
        ops.CreateModel(
            name='Community',
            fields=[
                ('id', fields.IntField(generated=True, primary_key=True, unique=True, db_index=True)),
                ('uid', fields.UUIDField(default=uuid4, unique=True)),
                ('created_at', fields.DatetimeField(auto_now=False, auto_now_add=True)),
                ('updated_at', fields.DatetimeField(auto_now=True, auto_now_add=False)),
                ('name', fields.CharField(max_length=100)),
                ('member_count', fields.IntField(default=1)),
            ],
            options={'table': 'community', 'app': 'community', 'pk_attr': 'id'},
            bases=['BaseModel'],
        ),
        ops.CreateModel(
            name='Membership',
            fields=[
                ('id', fields.IntField(generated=True, primary_key=True, unique=True, db_index=True)),
                ('uid', fields.UUIDField(default=uuid4, unique=True)),
                ('created_at', fields.DatetimeField(auto_now=False, auto_now_add=True)),
                ('updated_at', fields.DatetimeField(auto_now=True, auto_now_add=False)),
                ('user', fields.OneToOneField('user.User', source_field='user_id', db_constraint=True, to_field='id', related_name='membership', on_delete=OnDelete.CASCADE)),
                ('community', fields.ForeignKeyField('community.Community', source_field='community_id', db_constraint=True, to_field='id', on_delete=OnDelete.CASCADE)),
                ('is_head', fields.BooleanField(default=False)),
            ],
            options={'table': 'membership', 'app': 'community', 'pk_attr': 'id'},
            bases=['BaseModel'],
        ),
    ]
