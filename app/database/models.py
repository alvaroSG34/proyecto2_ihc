from sqlalchemy import String
from sqlalchemy.orm import Mapped, mapped_column

from app.database.connection import Base


class Usuario(Base):
    __tablename__ = "usuarios"

    id: Mapped[int] = mapped_column(primary_key=True)
    nombre: Mapped[str] = mapped_column(String(100))
    email: Mapped[str] = mapped_column(String(120), unique=True)
    password_hash: Mapped[str] = mapped_column(String(255))
    telefono: Mapped[str] = mapped_column(String(20))
    token_recuperacion: Mapped[str] = mapped_column(String(255), nullable=True)
    token_expiracion: Mapped[str] = mapped_column(String(255), nullable=True)
