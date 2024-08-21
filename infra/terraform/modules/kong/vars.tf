variable "name" {
  type        = string
  default     = "kong"
  description = "Name of nginx controller"
}

variable "repository" {
  type        = string
  default     = "https://charts.konghq.com"
  description = "Repository ghelm to install nginx controller"
}

variable "chart" {
  type        = string
  default     = "kong/ingress"
  description = "Chart of helm"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels of ingress"
}

variable "namespace" {
  type        = string
  default     = "kong"
  description = "Namespace name"
}

variable "create_namespace" {
  type        = bool
  default     = true
  description = "Enable create a namespace"
}