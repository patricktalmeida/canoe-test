from fastapi import FastAPI, Request
from datetime import datetime
import time
import json
import logging

logging.basicConfig(level=logging.INFO, format='%(message)s')
logger = logging.getLogger("uvicorn")

app = FastAPI()

@app.middleware("http")
async def log_requests(request: Request, call_next):
    response = await call_next(request)
    log_data = {
        "timestamp": int(time.time()),
        "method": request.method,
        "path": request.url.path,
        "client": request.client.host,
        "status_code": response.status_code
    }
    logger.info(json.dumps(log_data))
    return response

@app.get("/hello_world")
def hello_world():
    return {"message": "Hello World!"}

@app.get("/current_time")
def current_time(name: str):
    return {"timestamp": int(datetime.utcnow().timestamp()), "message": f"Hello {name}"}

@app.get("/healthcheck")
def healthcheck():
    return {"status": "healthy"}
