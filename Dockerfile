# 1. Imagen base: Python oficial en versión "slim" (más pequeña, sin extras)
FROM python:3.12-slim

# 2. Variables de entorno útiles en contenedores
#    - No generar archivos .pyc
#    - Mostrar logs al instante (sin buffer), para verlos con "docker logs"
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# 3. Directorio de trabajo dentro de la imagen
WORKDIR /app

# 4. Instalar dependencias ANTES de copiar el código:
#    Docker cachea cada capa; si solo cambias app.py, no reinstala dependencias.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copiar el código de la app
COPY app.py .

# 6. Seguridad: no ejecutar como root
RUN useradd --create-home --uid 10001 appuser
USER appuser

# 7. Documentar el puerto que usa la app
EXPOSE 8080

# 8. Comando de arranque: gunicorn (servidor de producción) en lugar del
#    servidor de desarrollo de Flask. 2 workers, escuchando en 0.0.0.0:8080.
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "2", "app:app"]
