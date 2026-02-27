from pydantic import BaseModel

class CreateCommunity(BaseModel):
    name: str