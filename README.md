# UniSport

Aplicación para crear partidos y completar equipos.

## Iniciar el backend

```powershell
.\.venv\Scripts\Activate.ps1
uvicorn app.main:app --reload
```

La documentación estará disponible en `http://127.0.0.1:8000/docs`.

## Configuración

1. Copia `.env.example` como `.env` si aún no existe.
2. Configura `DATABASE_URL` con tu PostgreSQL local.
3. Cuando se publique la aplicación, reemplaza ese valor por la URL de Neon.

# Guardar los requirements
pip freeze > requirements.txt

## Inicia el servidor:
uvicorn main:app --reload

# instalador para postgres
pip install "psycopg[binary]"

# PARA GENERAR CLAVE SECRETA
python -c "import secrets; print(secrets.token_urlsafe(32))"
