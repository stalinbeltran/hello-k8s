# hello-k8s

App "Hello World" en Python (Flask) para aprender contenedores, Kubernetes, Helm y Helmfile.

## Estructura

```
app.py, requirements.txt      # la app
Dockerfile                    # cómo se construye la imagen
charts/hello/                 # chart de Helm: plantillas de los recursos de Kubernetes
  values.yaml                 #   valores por defecto
helmfile.yaml.gotmpl          # qué se despliega: lo compartido del clúster + la app por entorno
cluster/                      # valores de lo compartido (Ingress controller)
environments/dev|prod/        # valores propios de cada entorno
```

## La app

- `GET /` → saludo + hostname del pod + versión
- `GET /healthz` → estado de salud
- Variable de entorno `GREETING` (por defecto `Hello, World!`)

## 0. Crear el clúster (una sola vez)

```bash
# Publica el NodePort 30080 del Ingress controller en localhost:8080 (sin port-forward)
minikube start --driver=docker --container-runtime=containerd \
  --kubernetes-version=v1.37.0 --memory=3072 --ports=127.0.0.1:8080:30080
```

Tras reiniciar el equipo basta con `minikube start` (el puerto publicado se conserva).
Los primeros segundos puede responder 503 mientras los pods arrancan.

## 1. Construir la imagen y cargarla en minikube

```bash
docker build -t hello-k8s:0.2.0 .
minikube image load hello-k8s:0.2.0   # minikube no ve las imágenes locales
```

## 2. Desplegar con Helmfile

Instala también el Ingress controller (ingress-nginx), compartido por todos los entornos.
Cada entorno de la app va en su namespace (`hello-dev`, `hello-prod`).

```bash
helmfile -e dev diff      # qué cambiaría (sin aplicar)
helmfile -e dev apply     # aplicar solo si hay cambios
helmfile -e prod apply
helmfile -e dev -l tier=app destroy   # desinstalar solo la app de dev
helmfile -e dev -l tier=cluster apply # solo lo compartido del clúster
```

## 3. Probar desde el navegador

Sin port-forward: http://dev.localhost:8080 y http://prod.localhost:8080

## Comandos útiles

```bash
kubectl get pods -n hello-prod                    # ver pods
kubectl logs -n hello-prod -l app.kubernetes.io/name=hello   # logs
helm history hello -n hello-prod                  # historial de despliegues
helm rollback hello 1 -n hello-prod               # volver a una revisión
```
