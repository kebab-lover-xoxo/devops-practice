from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI()

class EchoItem(BaseModel):
    message: str

@app.get('/api')
def read_root():
    return {'message': 'Hello from FastAPI backend!'}

@app.post('/api/echo')
def echo(item: EchoItem):
    return {'echo': item}
