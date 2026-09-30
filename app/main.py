from fastapi import FastAPI

from app.core.config import settings
from app.modules.auth.router import router as auth_router
from app.modules.partidos.router import router as partidos_router

app = FastAPI(title=settings.app_name)

app.include_router(auth_router)
app.include_router(partidos_router)


@app.get("/", tags=["Inicio"])
def inicio():
    return {"mensaje": "UniSport API funcionando"}
