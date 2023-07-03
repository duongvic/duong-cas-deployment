# kube-prometheus-stack

Installs the kube-prometheus stack, a collection of Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator.

## Prerequisites

- Kubernetes 1.16+
- Helm 3+

## Get Repo Info

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

## Customize `values.yaml` File

```yaml
## Create default rules for monitoring the cluster
##
defaultRules:
  create: true
  rules:
    alertmanager: true
    etcd: false
    general: true
    k8s: true
    kubeApiserver: true
    kubeApiserverAvailability: true
    kubeApiserverError: true
    kubeApiserverSlos: true
    kubelet: true
    kubePrometheusGeneral: true
    kubePrometheusNodeAlerting: true
    kubePrometheusNodeRecording: true
    kubernetesAbsent: true
    kubernetesApps: false
    kubernetesResources: true
    kubernetesStorage: true
    kubernetesSystem: true
    kubeScheduler: true
    kubeStateMetrics: true
    network: true
    node: true
    prometheus: true
    prometheusOperator: true
    time: true
```

```yaml
## Deprecated way to provide custom recording or alerting rules to be deployed into the cluster.
additionalPrometheusRules:
  - name: host-and-hardware
    groups:
      - name: host-and-hardware
        rules:
          - alert: HostOutOfMemory
            expr: node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes * 100 < 90
            for: 2m
            labels:
              severity: critical
            annotations:
              summary: Host out of memory (instance {{ $labels.instance }})
              description: Node memory is filling up (< 10% left)  VALUE = {{ $value }}  LABELS  {{ $labels }}
          - alert: HostMemoryUnderMemoryPressure
            expr: rate(node_vmstat_pgmajfault[1m]) > 1000
            for: 2m
            labels:
              severity: warning
            annotations:
              summary: Host memory under memory pressure (instance {{ $labels.instance }})
              description: The node is under heavy memory pressure. High rate of major page faults  VALUE = {{ $value }}  LABELS = {{ $labels }}
        ....

```

```yaml
- name: kubernetes-apps
  groups:
    - name: kubernetes-apps
      rules:
        - alert: KubernetesNodeReady
          expr: kube_node_status_condition{condition="Ready",status="true"} == 0
          for: 5m
          labels:
            severity: critical
          annotations:
            summary: Kubernetes Node ready (instance {{ $labels.instance }})
            description: Node {{ $labels.node }} has been unready for a long time  VALUE = {{ $value }}  LABELS = {{ $labels }}
        - alert: KubernetesMemoryPressure
          expr: kube_node_status_condition{condition="MemoryPressure",status="true"} == 1
          for: 2m
          labels:
            severity: critical
          annotations:
            summary: Kubernetes memory pressure (instance {{ $labels.instance }})
            description: Node {{ $labels.node }} has MemoryPressure condition  VALUE = {{ $value }}  LABELS = {{ $labels }}
```

```yaml
## Alertmanager configuration directives
## ref: https://prometheus.io/docs/alerting/configuration/#configuration-file
##      https://prometheus.io/webtools/alerting/routing-tree-editor/
##
config:
  global:
    resolve_timeout: 5m
    slack_api_url: "https://hooks.slack.com/services/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"
  route:
    group_by: [Alertname]
    # Send all notifications to me.
    receiver: slack-notifications
    group_wait: 30s
    group_interval: 5m
    repeat_interval: 12h
    routes:
      - match:
          alertname: DemoAlertName
        receiver: "slack-notifications"

  receivers:
    - name: slack-notifications
      slack_configs:
        - channel: "#dev-k8s-monitoring"
          send_resolved: true
          icon_url: https://avatars3.githubusercontent.com/u/3380462
          title: |-
            [{{ .Status | toUpper }}{{ if eq .Status "firing" }}:{{ .Alerts.Firing | len }}{{ end }}] {{ .CommonLabels.alertname }} for {{ .CommonLabels.job }}
            {{- if gt (len .CommonLabels) (len .GroupLabels) -}}
              {{" "}}(
              {{- with .CommonLabels.Remove .GroupLabels.Names }}
                {{- range $index, $label := .SortedPairs -}}
                  {{ if $index }}, {{ end }}
                  {{- $label.Name }}="{{ $label.Value -}}"
                {{- end }}
              {{- end -}}
              )
            {{- end }}
          text: >-
            {{ range .Alerts -}}
            *Alert:* {{ .Annotations.title }}{{ if .Labels.severity }} - `{{ .Labels.severity }}`{{ end }}

            *Description:* {{ .Annotations.description }}

            *Details:*
              {{ range .Labels.SortedPairs }} • *{{ .Name }}:* `{{ .Value }}`
              {{ end }}
            {{ end }}
```

```yaml
## Storage is the definition of how storage will be used by the Alertmanager instances.
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/storage.md
##
storage:
  volumeClaimTemplate:
    spec:
      storageClassName: linode-block-storage-retain
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

```yaml
## Prometheus StorageSpec for persistent data
## ref: https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/user-guides/storage.md
##
storageSpec:
  ## Using PersistentVolumeClaim
  ##
  volumeClaimTemplate:
    spec:
      storageClassName: linode-block-storage-retain
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
```

## Install Chart

### Create namespace

```sh
kubectl create ns monitoring
```

### Install Prometheus Stack

```sh
helm -n monitoring install prometheus prometheus-community/kube-prometheus-stack -f prometheus-community-values.yaml
```

### Check deployments and services

```sh
kubectl -n monitoring get pod
NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0          2d22h
prometheus-grafana-5587c4cdf8-qszgt                      2/2     Running   0          2d22h
prometheus-kube-prometheus-operator-5c5cd5b6db-s6p9j     1/1     Running   0          2d22h
prometheus-kube-state-metrics-6bfcd6f648-lkpq5           1/1     Running   0          2d22h
prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   1          2d22h
prometheus-prometheus-node-exporter-6p8kk                1/1     Running   0          2d22h
prometheus-prometheus-node-exporter-dctgb                1/1     Running   0          2d22h
prometheus-prometheus-node-exporter-rv2q5                1/1     Running   0          2d22h

```

```sh
kubectl -n monitoring get svc
NAME                                      TYPE           CLUSTER-IP       EXTERNAL-IP      PORT(S)                      AGE
alertmanager-operated                     ClusterIP      None             <none>           9093/TCP,9094/TCP,9094/UDP   2d22h
prometheus-grafana                        LoadBalancer   10.128.184.33    172.104.38.178   80:30081/TCP                 2d22h
prometheus-kube-prometheus-alertmanager   ClusterIP      10.128.249.216   <none>           9093/TCP                     2d22h
prometheus-kube-prometheus-operator       ClusterIP      10.128.34.167    <none>           443/TCP                      2d22h
prometheus-kube-prometheus-prometheus     ClusterIP      10.128.58.37     <none>           9090/TCP                     2d22h
prometheus-kube-state-metrics             ClusterIP      10.128.139.212   <none>           8080/TCP                     2d22h
prometheus-operated                       ClusterIP      None             <none>           9090/TCP                     2d22h
prometheus-prometheus-node-exporter       ClusterIP      10.128.58.251    <none>           9100/TCP                     2d22h
```

### Alert notifications via Slack

![slack-alert](./images/slack-alert.png)
