# hello-k8s

App "Hello World" en Python (Flask) para aprender contenedores, Kubernetes, Helm y Helmfile.

## Estructura

```
app.py, requirements.txt      # la app
Dockerfile                    # cómo se construye la imagen
charts/hello/                 # chart de Helm: plantillas de los recursos de Kubernetes
  values.yaml                 #   valores por defecto
helmfile.yaml.gotmpl          # qué se despliega en cada entorno
environments/dev|prod/        # valores propios de cada entorno
```

## La app

- `GET /` → saludo + hostname del pod + versión
- `GET /healthz` → estado de salud
- Variable de entorno `GREETING` (por defecto `Hello, World!`)

## 1. Construir la imagen y cargarla en minikube

```bash
docker build -t hello-k8s:0.2.0 .
minikube image load hello-k8s:0.2.0   # minikube no ve las imágenes locales
```

## 2. Desplegar con Helmfile

Cada entorno va en su namespace (`hello-dev`, `hello-prod`).

```bash
helmfile -e dev diff      # qué cambiaría (sin aplicar)
helmfile -e dev apply     # aplicar solo si hay cambios
helmfile -e prod apply
helmfile -e dev destroy   # desinstalar el entorno
```

## 3. Probar desde el navegador

```bash
minikube addons enable ingress        # una sola vez
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80
# → http://dev.localhost:8080  y  http://prod.localhost:8080
```

## Comandos útiles

```bash
kubectl get pods -n hello-prod                    # ver pods
kubectl logs -n hello-prod -l app.kubernetes.io/name=hello   # logs
helm history hello -n hello-prod                  # historial de despliegues
helm rollback hello 1 -n hello-prod               # volver a una revisión
```
