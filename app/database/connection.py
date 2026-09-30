from app.core.config import settings


def get_database_url() -> str:
    """Devuelve la conexión configurada para PostgreSQL local o Neon."""
    return settings.database_url
