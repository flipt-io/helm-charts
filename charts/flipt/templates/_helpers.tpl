{{/*
Expand the name of the chart.
*/}}
{{- define "flipt.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "flipt.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a fully qualified name for the migration job
*/}}
{{- define "flipt.migration_name" -}}
{{- include "flipt.fullname" . | trunc 53 | trimSuffix "-" }}-migration
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "flipt.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "flipt.labels" -}}
helm.sh/chart: {{ include "flipt.chart" . }}
{{ include "flipt.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "flipt.selectorLabels" -}}
app.kubernetes.io/name: {{ include "flipt.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "flipt.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "flipt.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Renders a value that contains template.
Usage:
{{ include "common.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}

{{/*
Return  the proper Storage Class
{{ include "common.storage.class" ( dict "persistence" .Values.path.to.the.persistence "global" $) }}
*/}}
{{- define "common.storage.class" -}}
{{- $storageClass := .persistence.storageClass -}}
{{- if .global -}}
    {{- if .global.storageClass -}}
        {{- $storageClass = .global.storageClass -}}
    {{- end -}}
{{- end -}}
{{- if $storageClass -}}
  {{- if (eq "-" $storageClass) -}}
      {{- printf "storageClassName: \"\"" -}}
  {{- else }}
      {{- printf "storageClassName: %s" $storageClass -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Pod annotations
*/}}
{{- define "common.classes.podAnnotations" -}}
  {{- if .Values.podAnnotations -}}
    {{- tpl (toYaml .Values.podAnnotations) . | nindent 0 -}}
  {{- end -}}
  {{- printf "checksum/config: %v" (join "," .Values.flipt | sha256sum) | nindent 0 -}}
{{- end -}}

{{/*
Deployment annotations
*/}}
{{- define "common.classes.deploymentAnnotations" -}}
  {{- if .Values.deploymentAnnotations -}}
    {{- tpl (toYaml .Values.deploymentAnnotations) . | nindent 0 -}}
  {{- end -}}
  {{- printf "checksum/config: %v" (join "," .Values.flipt | sha256sum) | nindent 0 -}}
{{- end -}}

{{/* Return the target Kubernetes version */}}
{{- define "flipt.tools.kubeVersion" -}}
{{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride }}
{{- end }}

{{/* Return the appropriate apiVersion for autoscaling */}}
{{- define "flipt.apiVersion.autoscaling" -}}
{{- if (.Values.apiVersionOverrides).autoscaling -}}
{{- print .Values.apiVersionOverrides.autoscaling -}}
{{- else if semverCompare "<1.23-0" (include "flipt.tools.kubeVersion" .) -}}
{{- print "autoscaling/v2beta1" -}}
{{- else -}}
{{- print "autoscaling/v2" -}}
{{- end -}}
{{- end -}}
