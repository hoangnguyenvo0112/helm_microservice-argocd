{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "customer-support-panel-frontend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "customer-support-panel-frontend.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the chart image name.
*/}}
{{- define "customer-support-panel-frontend.image-name" -}}
{{- printf "%s/%s:%s" .Values.image.registry .Values.image.repository (.Values.image.tag | default .Chart.AppVersion) -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "customer-support-panel-frontend.fullname" -}}
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
Allow customization of the instance label value.
*/}}
{{- define "customer-support-panel-frontend.instance-name" -}}
{{- default (printf "%s-%s" .Release.Name (include "customer-support-panel-frontend.namespace" .)) .Values.instanceLabelOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Shared labels used for selector */}}
{{- define "customer-support-panel-frontend.labelselector" -}}
app.kubernetes.io/name: {{ template "customer-support-panel-frontend.name" . }}
app.kubernetes.io/instance: {{ template "customer-support-panel-frontend.instance-name" . }}
{{- end }}

{{/* Shared labels used in metadata */}}
{{- define "customer-support-panel-frontend.labels" -}}
{{ include "customer-support-panel-frontend.labelselector" . }}
helm.sh/chart: {{ template "customer-support-panel-frontend.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.commonLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Construct the namespace for all namespaced resources.
*/}}
{{- define "customer-support-panel-frontend.namespace" -}}
{{- if .Values.namespaceOverride -}}
{{- .Values.namespaceOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{/*
The name of the service account to use.
*/}}
{{- define "customer-support-panel-frontend.serviceAccountName" -}}
{{- default (include "customer-support-panel-frontend.fullname" .) .Values.serviceAccount.name -}}
{{- end -}}

{{/*
The name of the ClusterRole and ClusterRoleBinding to use.
*/}}
{{- define "customer-support-panel-frontend.clusterRoleName" -}}
{{- (printf "%s-%s" (include "customer-support-panel-frontend.fullname" .) (include "customer-support-panel-frontend.namespace" .)) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Generate/load self-signed certificate for admission webhooks.
*/}}
{{- define "customer-support-panel-frontend.webhook_cert" -}}
{{- $cert := lookup "v1" "Secret" (include "customer-support-panel-frontend.namespace" .) "frontend-webhook-cert" -}}
{{- if $cert -}}
Cert: {{ index $cert.data "tls.crt" }}
Key: {{ index $cert.data "tls.key" }}
{{- else -}}
{{- $altNames := list (printf "webhook.%s.svc" (include "customer-support-panel-frontend.namespace" .)) -}}
{{- $cert := genSelfSignedCert (printf "webhook.%s.svc" (include "customer-support-panel-frontend.namespace" .)) (list) $altNames 3650 -}}
Cert: {{ $cert.Cert | b64enc }}
Key: {{ $cert.Key | b64enc }}
{{- end -}}
{{- end -}}

{{/*
Render a complete tree, even values that contain templates.
*/}}
{{- define "customer-support-panel-frontend.render" -}}
{{- if typeIs "string" .value -}}
{{- tpl .value .context -}}
{{- else -}}
{{- tpl (.value | toYaml) .context -}}
{{- end -}}
{{- end -}}

{{/*
Generate command-line arguments from a YAML tree.
*/}}
{{- define "customer-support-panel-frontend.yaml2CommandLineArgsRec" -}}
{{- $path := .path -}}
{{- range $key, $value := .content -}}
    {{- if kindIs "map" $value -}}
        {{- include "customer-support-panel-frontend.yaml2CommandLineArgsRec" (dict "path" (printf "%s.%s" $path $key) "content" $value) -}}
    {{- else -}}
        {{- with $value  }}
--{{ join "." (list $path $key)}}={{ join "," $value }}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{- define "customer-support-panel-frontend.yaml2CommandLineArgs" -}}
{{- range ((regexSplit "\n" ((include "customer-support-panel-frontend.yaml2CommandLi
