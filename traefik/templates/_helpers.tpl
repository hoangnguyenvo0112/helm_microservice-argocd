{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "traefik.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts
*/}}
{{- define "traefik.namespace" -}}
  {{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "traefik.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "traefik.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
The name of the service account to use
*/}}
{{- define "traefik.serviceAccountName" -}}
{{- default (include "traefik.fullname" .) .Values.serviceAccount.name -}}
{{- end -}}

{{/*
Construct the path for the providers.kubernetesingress.ingressendpoint.publishedservice.
By convention this will simply use the <namespace>/<service-name> to match the name of the
service generated.
Users can provide an override for an explicit service they want bound via `.Values.providers.kubernetesIngress.publishedService.pathOverride`
*/}}
{{- define "providers.kubernetesIngress.publishedServicePath" -}}
{{- $defServiceName := printf "%s/%s" (include "traefik.namespace" .) (include "traefik.fullname" .) -}}
{{- $servicePath := default $defServiceName .Values.providers.kubernetesIngress.publishedService.pathOverride }}
{{- print $servicePath | trimSuffix "-" -}}
{{- end -}}

{{/*
Construct a comma-separated list of whitelisted namespaces
*/}}
{{- define "providers.kubernetesIngress.namespaces" -}}
{{- default (include "traefik.namespace" .) (join "," .Values.providers.kubernetesIngress.namespaces) }}
{{- end -}}
{{- define "providers.kubernetesCRD.namespaces" -}}
{{- default (include "traefik.namespace" .) (join "," .Values.providers.kubernetesCRD.namespaces) }}
{{- end -}}
