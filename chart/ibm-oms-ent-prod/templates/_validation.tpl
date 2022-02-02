# Licensed Materials - Property of IBM
# IBM Order Management Software (5725-D10)
# (C) Copyright IBM Corp. 2021 All Rights Reserved.
# US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

{{/*
A function to check for mandatory arguments
*/}}
{{- define "om-chart.mandatoryArgumentsCheck" -}}
{{- if . -}}
    true
{{- else -}}
    false
{{- end -}}
{{- end -}}


{{/*
Main function to test the input validations
*/}}
{{- define "om-chart.validateInput" -}}

{{- $result := include "om-chart.mandatoryArgumentsCheck" .Values.global.license -}}
{{- if eq $result "false" -}}
{{- required ".Values.global.license cannot be empty." .Values.global.license  -}}
{{- end -}}

{{- $result := include "om-chart.mandatoryArgumentsCheck" .Values.global.licenseStoreCallCenter -}}
{{- if eq $result "false" -}}
{{- required ".Values.global.licenseStoreCallCenter cannot be empty." .Values.global.licenseStoreCallCenter  -}}
{{- end -}}

{{- $result := include "om-chart.mandatoryArgumentsCheck" .Values.global.database.port -}}
{{- if eq $result "false" -}}
{{- required ".Values.global.database.port cannot be empty." .Values.global.database.port  -}}
{{- end -}}

{{- $result := include "om-chart.mandatoryArgumentsCheck" .Values.global.persistence.claims.name -}}	
{{- if eq $result "false" -}}	
{{- required ".Values.global.persistence.claims.name cannot be empty." .Values.global.persistence.claims.name  -}}	
{{- end -}}

{{- end -}}