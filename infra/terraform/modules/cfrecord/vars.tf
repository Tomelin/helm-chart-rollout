##############################
## CLOUDFLARE
# variable "cloudflare_account" {
#   type        = string
#   description = "Account of cloudflare"
# }

variable "cloudflare_domain" {
  type        = string
  default     = "synera.com.br"
  description = "Domain to create a new dns record"
}

# variable "cloudflare_dns_token" {
#   type        = string
#   description = "DNS to authentication in cloudflare"
#   sensitive   = true
# }

variable "cloudflare_dns_address" {
  type        = string
  description = "IP address to create a new record"
}