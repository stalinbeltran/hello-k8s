# hello-k8s

App "Hello World" en Python (Flask) para aprender contenedores, Kubernetes, Helm y Helmfile.

## Endpoints
- `GET /` → saludo + hostname del contenedor
- `GET /healthz` → estado de salud

## Variables de entorno
- `GREETING` (por defecto `Hello, World!`)
- `PORT` (por defecto `8080`)
