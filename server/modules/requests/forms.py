from pydantic import BaseModel

class CreateRequest(BaseModel):
    title: str
    description: str