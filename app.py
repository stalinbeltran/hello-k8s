import os
import socket

from flask import Flask, jsonify

app = Flask(__name__)

GREETING = os.environ.get("GREETING", "Hello, World!")


@app.get("/")
def hello():
    # El hostname nos dirá qué contenedor/pod respondió (útil en Kubernetes)
    return jsonify(message=GREETING, host=socket.gethostname())


@app.get("/healthz")
def healthz():
    # Endpoint de salud para los probes de Kubernetes más adelante
    return jsonify(status="ok")


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 8080)))
