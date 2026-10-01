from fastapi import APIRouter
from fastapi import Depends

from app.database.models import Usuario
from app.modules.auth.service import get_current_user

router = APIRouter(prefix="/api/partidos", tags=["Partidos"])


@router.get("/mis-partidos")
def mis_partidos(usuario: Usuario = Depends(get_current_user)):
    return {"nombre": usuario.nombre, "partidos": []}
