from sqlalchemy import select
from sqlalchemy.orm import Session

from app.database.models import Partido
from app.database.models import Usuario
from app.modules.partidos.schemas import PartidoCreate, PartidoUpdate


def listar_partidos(usuario: Usuario, db: Session) -> list[Partido]:
    return list(
        db.scalars(
            select(Partido)
            .where(Partido.usuario_id == usuario.id)
            .order_by(Partido.fecha, Partido.id)
        ).all()
    )


def obtener_partido(
    partido_id: int,
    usuario: Usuario,
    db: Session,
) -> Partido | None:
    return db.scalar(
        select(Partido).where(
            Partido.id == partido_id,
            Partido.usuario_id == usuario.id,
        )
    )


def crear_partido(
    datos: PartidoCreate,
    usuario: Usuario,
    db: Session,
) -> Partido:
    partido = Partido(
        usuario_id=usuario.id,
        nombre=datos.nombre.strip(),
        cantidad_jugadores=datos.cantidad_jugadores,
        ubicacion=datos.ubicacion.strip(),
        tiempo_min=(
            datos.tiempo_min.strip()
            if datos.tiempo_min is not None
            else None
        ),
        fecha=datos.fecha,
    )

    db.add(partido)
    db.commit()
    db.refresh(partido)

    return partido


def actualizar_partido(
    partido: Partido,
    datos: PartidoUpdate,
    db: Session,
) -> Partido:
    cambios = datos.model_dump(exclude_unset=True)

    for campo in ("nombre", "ubicacion", "tiempo_min"):
        if campo in cambios and cambios[campo] is not None:
            cambios[campo] = cambios[campo].strip()

    for campo, valor in cambios.items():
        setattr(partido, campo, valor)

    db.commit()
    db.refresh(partido)

    return partido


def eliminar_partido(partido: Partido, db: Session) -> None:
    db.delete(partido)
    db.commit()
