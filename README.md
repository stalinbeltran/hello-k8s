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
docker build -t hello-k8s:0.2.0 .

# Ejecutar el contenedor
docker run -d --name hello -p 8080:8080 -e GREETING="Hola!" hello-k8s:0.2.0

# Probar
curl localhost:8080/

# Ver logs / detener y borrar
docker logs hello
docker rm -f hello
```

## Kubernetes con manifiestos (minikube)

> Referencia didáctica: la app ahora se despliega con Helm (ver abajo).
> No mezclar: si está instalada con Helm, no aplicar `k8s/`.

```bash
# minikube no ve las imágenes locales: hay que cargarlas
docker build -t hello-k8s:0.2.0 .
minikube image load hello-k8s:0.2.0

# Desplegar (ConfigMap + Deployment + Service)
kubectl apply -f k8s/
kubectl rollout status deployment/hello

# Ver recursos
kubectl get pods,svc -l app=hello

# Probar (el Service reparte entre los pods)
curl http://$(minikube ip):30080/

# Acceso desde el navegador (Windows) vía Ingress
minikube addons enable ingress        # una sola vez
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80
# → abrir http://localhost:8080 y recargar: cada petición la puede atender otro pod

# Escalar, ver logs, borrar
kubectl scale deployment/hello --replicas=5
kubectl logs -l app=hello
kubectl delete -f k8s/
```

## Helm

> Ahora los despliegues se hacen con Helmfile (ver abajo); estos comandos quedan como referencia.

El chart está en `charts/hello/`. Los valores configurables están en `values.yaml`.

```bash
# Ver los YAML que generaría (sin instalar)
helm template hello charts/hello

# Instalar
helm install hello charts/hello

# Cambiar valores sin tocar archivos
helm upgrade hello charts/hello --set greeting="Hola!" --set replicaCount=5

# Historial y volver atrás
helm history hello
helm rollback hello 1

# Desinstalar
helm uninstall hello
```

## Helmfile (entornos dev y prod)

`helmfile.yaml.gotmpl` declara el release `hello`; los valores de cada entorno están en
`environments/<entorno>/hello.yaml`. Cada entorno va en su namespace (`hello-dev`, `hello-prod`).

```bash
helmfile -e dev diff      # qué cambiaría (sin aplicar)
helmfile -e dev apply     # aplicar solo si hay cambios
helmfile -e prod apply
helmfile -e dev destroy   # desinstalar el entorno
```

Acceso desde el navegador (un solo port-forward para ambos entornos):

```bash
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80
# → http://dev.localhost:8080  y  http://prod.localhost:8080
```
