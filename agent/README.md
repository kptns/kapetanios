# Kapetanios Agent

## Installation

You can install the Kapetanios Agent using Helm with the following commands:

```bash
# Add the Kapetanios Helm repository
helm repo add kapetanios https://kapetanios-artifactory.nyc3.digitaloceanspaces.com/helm-charts

# Update Helm repositories
helm repo update

# Install the Kapetanios Agent
helm install kapetanios-agent kapetanios/kapetanios-agent
```

After installation, you can apply your custom configuration:

```bash
kubectl apply -f kapetanios-agent-values.yaml
```

## About

The Kapetanios Agent is a Kubernetes agent that helps you manage Kubernetes deployment replicas count using AI to predict the load and ensure optimization and quality service.

## Configuration

To customize the Kapetanios Agent installation, you can modify the `kapetanios-agent-values.yaml` file according to your requirements.
