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
docker build -t hello-k8s:0.1.1 .

# Ejecutar el contenedor
docker run -d --name hello -p 8080:8080 -e GREETING="Hola!" hello-k8s:0.1.1

# Probar
curl localhost:8080/

# Ver logs / detener y borrar
docker logs hello
docker rm -f hello
```

## Kubernetes (minikube)

```bash
# minikube no ve las imágenes locales: hay que cargarlas
docker build -t hello-k8s:0.1.1 .
minikube image load hello-k8s:0.1.1

# Desplegar (ConfigMap + Deployment + Service)
kubectl apply -f k8s/
kubectl rollout status deployment/hello

# Ver recursos
kubectl get pods,svc -l app=hello

# Probar (el Service reparte entre los pods)
curl http://$(minikube ip):30080/

# Escalar, ver logs, borrar
kubectl scale deployment/hello --replicas=5
kubectl logs -l app=hello
kubectl delete -f k8s/
```
