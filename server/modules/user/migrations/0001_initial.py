from tortoise import migrations
from tortoise.migrations import operations as ops
from uuid import uuid4
from tortoise import fields

class Migration(migrations.Migration):
    initial = True

    operations = [
        ops.CreateModel(
            name='User',
            fields=[
                ('id', fields.IntField(generated=True, primary_key=True, unique=True, db_index=True)),
                ('uid', fields.UUIDField(default=uuid4, unique=True)),
                ('created_at', fields.DatetimeField(auto_now=False, auto_now_add=True)),
                ('updated_at', fields.DatetimeField(auto_now=True, auto_now_add=False)),
                ('name', fields.CharField(max_length=100)),
                ('phone', fields.CharField(unique=True, max_length=20)),
                ('score', fields.IntField(default=0)),
                ('is_verified', fields.BooleanField(default=False)),
            ],
            options={'table': 'user', 'app': 'user', 'pk_attr': 'id'},
            bases=['BaseModel'],
        ),
    ]
