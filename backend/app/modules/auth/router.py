from datetime import datetime, timedelta, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.core.security import (
    create_access_token,
    create_recovery_token,
    hash_password,
    verify_password,
)
from app.database.connection import get_db
from app.database.models import Usuario
from app.modules.auth.schemas import (
    AuthTokenResponse,
    CambiarPassword,
    CambiarPasswordAutenticado,
    LoginRequest,
    RecuperarPassword,
    UsuarioCreate,
    UsuarioResponse,
)
from app.modules.auth.service import get_current_user


router = APIRouter(
    prefix="/api/auth",
    tags=["Autenticación"]
)


def usuario_response(usuario: Usuario) -> UsuarioResponse:
    return UsuarioResponse(
        id=usuario.id,
        nombre=usuario.nombre,
        email=usuario.email
    )


def crear_usuario(datos: UsuarioCreate, db: Session) -> Usuario:
    email = datos.email.lower().strip()

    existente = db.scalar(
        select(Usuario).where(
            Usuario.email == email
        )
    )

    if existente:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="El email ya está registrado"
        )

    usuario = Usuario(
        nombre=datos.nombre.strip(),
        email=email,
        password_hash=hash_password(datos.password),
        telefono=datos.telefono,
    )

    db.add(usuario)
    db.commit()
    db.refresh(usuario)

    return usuario


def autenticar_usuario(
    datos: LoginRequest,
    db: Session
) -> Usuario:

    usuario = db.scalar(
        select(Usuario).where(
            Usuario.email == datos.email.lower().strip()
        )
    )

    if (
        not usuario
        or not verify_password(
            datos.password,
            usuario.password_hash
        )
    ):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email o contraseña incorrectos"
        )

    return usuario


@router.post(
    "/registro",
    response_model=AuthTokenResponse,
    status_code=status.HTTP_201_CREATED
)
def registrar_usuario(
    datos: UsuarioCreate,
    db: Session = Depends(get_db)
):

    usuario = crear_usuario(datos, db)

    return AuthTokenResponse(
        access_token=create_access_token(usuario.id),
        usuario=usuario_response(usuario)
    )


@router.post(
    "/login",
    response_model=AuthTokenResponse
)
def login(
    datos: LoginRequest,
    db: Session = Depends(get_db)
):

    usuario = autenticar_usuario(datos, db)

    return AuthTokenResponse(
        access_token=create_access_token(usuario.id),
        usuario=usuario_response(usuario)
    )


@router.post("/logout")
def logout():

    return {
        "mensaje": "Sesión cerrada correctamente"
    }


@router.get(
    "/yo",
    response_model=UsuarioResponse
)
def usuario_actual(
    usuario: Usuario = Depends(get_current_user)
):

    return usuario_response(usuario)


@router.post("/cambiar-password-auth")
def cambiar_password_autenticado(
    datos: CambiarPasswordAutenticado,
    usuario: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if not verify_password(datos.contrasena_actual, usuario.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="La contraseña actual es incorrecta",
        )

    if datos.contrasena_actual == datos.nueva_password:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="La nueva contraseña debe ser distinta a la actual",
        )

    usuario.password_hash = hash_password(datos.nueva_password)
    db.commit()

    return {"mensaje": "Contraseña actualizada"}


@router.post("/recuperar")
def recuperar_password(
    datos: RecuperarPassword,
    db: Session = Depends(get_db)
):

    usuario = db.scalar(
        select(Usuario).where(
            Usuario.email == datos.email.lower().strip()
        )
    )

    if not usuario:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuario no encontrado"
        )

    token = create_recovery_token()

    usuario.token_recuperacion = token

    usuario.token_expiracion = (
        datetime.now(timezone.utc)
        + timedelta(minutes=15)
    )

    db.commit()

    return {
        "mensaje": "Token generado para recuperar contraseña",
        "token": token
    }


@router.post("/cambiar-password")
def cambiar_password(
    datos: CambiarPassword,
    db: Session = Depends(get_db)
):

    usuario = db.scalar(
        select(Usuario).where(
            Usuario.token_recuperacion == datos.token
        )
    )

    if (
        not usuario
        or not usuario.token_expiracion
        or usuario.token_expiracion < datetime.now(timezone.utc)
    ):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Token inválido o vencido"
        )

    usuario.password_hash = hash_password(
        datos.nueva_password
    )

    usuario.token_recuperacion = None
    usuario.token_expiracion = None

    db.commit()

    return {
        "mensaje": "Contraseña actualizada"
    }
