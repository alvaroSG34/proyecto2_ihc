from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.database.connection import get_db
from app.database.models import Usuario
from app.modules.auth.service import get_current_user
from app.modules.partidos.schemas import (
    PartidoCreate,
    PartidoResponse,
    PartidoUpdate,
)
from app.modules.partidos.service import (
    actualizar_partido,
    crear_partido,
    eliminar_partido,
    listar_partidos,
    obtener_partido,
)


router = APIRouter(prefix="/api/partidos", tags=["Partidos"])


def partido_no_encontrado() -> HTTPException:
    return HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Partido no encontrado",
    )


@router.post(
    "",
    response_model=PartidoResponse,
    status_code=status.HTTP_201_CREATED,
)
def crear(
    datos: PartidoCreate,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
) -> PartidoResponse:
    return crear_partido(datos, usuario, db)


@router.get("", response_model=list[PartidoResponse])
def listar(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
) -> list[PartidoResponse]:
    return listar_partidos(usuario, db)


@router.get("/mis-partidos", response_model=list[PartidoResponse])
def mis_partidos(
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
) -> list[PartidoResponse]:
    return listar_partidos(usuario, db)


@router.get("/{partido_id}", response_model=PartidoResponse)
def obtener(
    partido_id: int,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
) -> PartidoResponse:
    partido = obtener_partido(partido_id, usuario, db)
    if partido is None:
        raise partido_no_encontrado()

    return partido


@router.put("/{partido_id}", response_model=PartidoResponse)
def actualizar(
    partido_id: int,
    datos: PartidoUpdate,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
) -> PartidoResponse:
    partido = obtener_partido(partido_id, usuario, db)
    if partido is None:
        raise partido_no_encontrado()

    return actualizar_partido(partido, datos, db)


@router.delete(
    "/{partido_id}",
    status_code=status.HTTP_204_NO_CONTENT,
)
def eliminar(
    partido_id: int,
    db: Session = Depends(get_db),
    usuario: Usuario = Depends(get_current_user),
) -> None:
    partido = obtener_partido(partido_id, usuario, db)
    if partido is None:
        raise partido_no_encontrado()

    eliminar_partido(partido, db)
