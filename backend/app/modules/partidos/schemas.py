from datetime import datetime

from pydantic import BaseModel, ConfigDict, Field


class PartidoBase(BaseModel):
    nombre: str = Field(min_length=1, max_length=100)
    cantidad_jugadores: int
    ubicacion: str = Field(min_length=1, max_length=255)
    tiempo_min: str | None = Field(default=None, max_length=20)
    fecha: datetime | None = None


class PartidoCreate(PartidoBase):
    pass


class PartidoUpdate(BaseModel):
    nombre: str | None = Field(default=None, min_length=1, max_length=100)
    cantidad_jugadores: int | None = None
    ubicacion: str | None = Field(default=None, min_length=1, max_length=255)
    tiempo_min: str | None = Field(default=None, max_length=20)
    fecha: datetime | None = None


class PartidoResponse(PartidoBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
