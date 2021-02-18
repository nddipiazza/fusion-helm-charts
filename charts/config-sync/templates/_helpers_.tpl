{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "fusion.config-sync.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fusion.config-sync.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "fusion.config-sync.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "fusion.config-sync.serviceName" -}}
{{- printf "config-sync" -}}
{{- end -}}

{{/*
Define the Spring Profile
*/}}
{{- define "fusion.config-sync.springProfs" -}}
{{- if .Values.springProfilesOverride -}}
{{- printf "%s" .Values.springProfilesOverride -}}
{{- else -}}
{{- printf "%s" .Values.springProfiles -}}
{{- end -}}
{{- end -}}

{{/*
Define the Logstash Hosts
*/}}
{{- define "fusion.config-sync.logstashHostStr" -}}
{{- if .Values.logstashHost -}}
{{- .Values.logstashHost -}}
{{- else -}}
{{- printf "%s-%s:4560" .Release.Name "logstash" -}}
{{- end -}}
{{- end -}}

{{/*
  Define the labels that should be applied to all resources in the chart
*/}}
{{- define "fusion.config-sync.labels" -}}
helm.sh/chart: "{{ include "fusion.config-sync.chart" . }}"
app.kubernetes.io/name: "{{ template "fusion.config-sync.name" . }}"
app.kubernetes.io/managed-by: "{{ .Release.Service }}"
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
app.kubernetes.io/component: "config-sync"
app.kubernetes.io/part-of: "fusion"
{{- end -}}

{{/*
Define the service url for pulsar broker
*/}}
{{- define "fusion.config-sync.pulsarServiceUrl" -}}
{{- $tlsEnabled := ( eq ( include "fusion.tls.enabled" . ) "true" ) }}
{{- if .Values.global -}}
{{- if .Values.global.pulsarServiceUrl -}}
{{- printf "%s" .Values.global.pulsarServiceUrl -}}
{{- end -}}
{{- end -}}
{{- if .Values.pulsarServiceUrl -}}
{{- printf "%s" .Values.pulsarServiceUrl -}}
{{- else -}}
{{- printf "%s://%s-pulsar-broker:%s" ( ternary "pulsar+ssl" "pulsar" $tlsEnabled  )  .Release.Name ( (ternary .Values.pulsarServiceTLSPort .Values.pulsarServicePort $tlsEnabled ) ) -}}
{{- end -}}
{{- end -}}

{{/*
Define the admin url for pulsar broker
*/}}
{{- define "fusion.config-sync.pulsarAdminUrl" -}}
{{- $tlsEnabled := ( eq ( include "fusion.tls.enabled" . ) "true" ) }}
{{- if .Values.global -}}
{{- if .Values.global.pulsarAdminUrl -}}
{{- printf "%s" .Values.global.pulsarAdminUrl -}}
{{- end -}}
{{- end -}}
{{- if .Values.pulsarAdminUrl -}}
{{- printf "%s" .Values.pulsarAdminUrl -}}
{{- else -}}
{{- printf "%s://%s-pulsar-broker:%s" ( ternary "https" "http" $tlsEnabled  )  .Release.Name ( (ternary .Values.pulsarTLSPort .Values.pulsarPort $tlsEnabled ) ) -}}
{{- end -}}
{{- end -}}

{{/*
Define the kubernetes namespace variable
*/}}
{{- define "fusion.config-sync.kubeNamespace" -}}
{{- if .Values.namespaceOverride -}}
{{- printf "%s" .Values.namespaceOverride -}}
{{- else -}}
{{- printf "%s" .Release.Namespace -}}
{{- end -}}
{{- end -}}

{{- define "fusion.config-sync.solrSvc" -}}
{{- if .Values.solrSvc -}}
{{- printf "%s" .Values.solrSvc -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "solr-svc" -}}
{{- end -}}
{{- end -}}
