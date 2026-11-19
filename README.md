# hello-k8s

App "Hello World" en Python (Flask) para aprender contenedores, Kubernetes, Helm y Helmfile.

## Endpoints
- `GET /` → saludo + hostname del contenedor
- `GET /healthz` → estado de salud

## Variables de entorno
- `GREETING` (por defecto `Hello, World!`)
- `PORT` (por defecto `8080`)

## Docker

```bash
# Construir la imagen
docker build -t hello-k8s:0.1.0 .

# Ejecutar el contenedor
docker run -d --name hello -p 8080:8080 -e GREETING="Hola!" hello-k8s:0.1.0

# Probar
curl localhost:8080/

# Ver logs / detener y borrar
docker logs hello
docker rm -f hello
```
