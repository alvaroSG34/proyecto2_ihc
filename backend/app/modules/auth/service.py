from fastapi import Depends, HTTPException, Request, status
import jwt
from sqlalchemy.orm import Session

from app.core.security import decode_access_token
from app.database.connection import get_db
from app.database.models import Usuario


COOKIE_NAME = "access_token"


def get_user_from_token(token: str | None, db: Session) -> Usuario:
    if not token:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Sesión requerida")

    try:
        user_id = decode_access_token(token)
    except (jwt.InvalidTokenError, KeyError, ValueError):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Sesión inválida")

    usuario = db.get(Usuario, user_id)
    if not usuario:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Usuario no encontrado")
    return usuario


def get_current_user(request: Request, db: Session = Depends(get_db)) -> Usuario:
    return get_user_from_token(request.cookies.get(COOKIE_NAME), db)
