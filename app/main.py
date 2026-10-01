from pathlib import Path

from fastapi import FastAPI, Request
from fastapi.responses import FileResponse, RedirectResponse
from fastapi.staticfiles import StaticFiles

from app.core.config import settings
from app.database.connection import SessionLocal
from app.modules.auth.router import router as auth_router
from app.modules.auth.service import COOKIE_NAME, get_user_from_token
from app.modules.partidos.router import router as partidos_router


FRONTEND_DIR = Path(__file__).resolve().parent.parent / "frontend"


app = FastAPI(title=settings.app_name)
app.mount("/static", StaticFiles(directory=FRONTEND_DIR), name="static")

app.include_router(auth_router)
app.include_router(partidos_router)


@app.get("/", include_in_schema=False)
def inicio():
    return FileResponse(FRONTEND_DIR / "index.html")


@app.get("/login", include_in_schema=False)
def pagina_login():
    return FileResponse(FRONTEND_DIR / "login.html")


@app.get("/registro", include_in_schema=False)
def pagina_registro():
    return FileResponse(FRONTEND_DIR / "registro.html")


@app.get("/recuperar", include_in_schema=False)
def pagina_recuperar():
    return FileResponse(FRONTEND_DIR / "recuperar.html")


@app.get("/mis-partidos", include_in_schema=False)
def pagina_mis_partidos(request: Request):
    db = SessionLocal()
    try:
        get_user_from_token(request.cookies.get(COOKIE_NAME), db)
    except Exception:
        return RedirectResponse("/login", status_code=303)
    finally:
        db.close()
    return FileResponse(FRONTEND_DIR / "mis-partidos.html")
