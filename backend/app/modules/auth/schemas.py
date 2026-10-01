from pydantic import BaseModel


class UsuarioCreate(BaseModel):
    nombre: str
    email: str
    password: str
    telefono: str | None = None


class UsuarioResponse(BaseModel):
    id: int
    nombre: str
    email: str


class AuthTokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    usuario: UsuarioResponse


class LoginRequest(BaseModel):
    email: str
    password: str


class RecuperarPassword(BaseModel):
    email: str


class CambiarPassword(BaseModel):
    token: str
    nueva_password: str


class CambiarPasswordAutenticado(BaseModel):
    contrasena_actual: str
    nueva_password: str
