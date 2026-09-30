from fastapi import APIRouter

router = APIRouter(prefix="/api/auth", tags=["Autenticación"])


@router.get("/estado")
def estado_auth():
    """Ruta temporal para comprobar que el módulo está conectado."""
    return {"modulo": "autenticación", "estado": "pendiente de implementación"}
