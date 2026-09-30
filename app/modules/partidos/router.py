from fastapi import APIRouter

router = APIRouter(prefix="/api/partidos", tags=["Partidos"])


@router.get("/estado")
def estado_partidos():
    """La ruta privada /mis-partidos se añadirá tras implementar la sesión."""
    return {"modulo": "partidos", "estado": "pendiente de implementación"}
