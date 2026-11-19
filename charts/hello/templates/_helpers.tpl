{{/*
Funciones reutilizables. No generan recursos (empiezan por "_").
*/}}

{{/* Nombre completo: "<release>-hello", o solo "<release>" si ya contiene "hello" */}}
{{- define "hello.fullname" -}}
{{- if contains .Chart.Name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Etiquetas para seleccionar los pods (no deben cambiar entre versiones) */}}
{{- define "hello.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Etiquetas comunes para todos los recursos */}}
{{- define "hello.labels" -}}
{{ include "hello.selectorLabels" . }}
app.kubernetes.io/version: {{ .Values.image.tag | default .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end -}}
