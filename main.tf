terraform {
    required_providers {
      digitalocean = {
        source = "digitalocean/digitalocean"
        version = "~> 2.0"
      }
    }   
}

provider "digitalocean" {
    token = var.digitalocean_token
}

resource "digitalocean_kubernetes_cluster" "k8s" {
  name   = var.nome_cluster
  region = "nyc1"
  version = "1.21.5-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-4gb"
    node_count = 3
  }
}

variable "digitalocean_token"{}
variable "nome_cluster"{}

output "kubernetes_endpoint" {
    value = digitalocean_kubernetes_cluster.k8s.endpoint
}
resource "local_file" "kube_config" {
    content     = digitalocean_kubernetes_cluster.k8s.kube_config.0.raw_config
    filename = "kube_config.yaml"
}
