data "cloudflare_zone" "domain" {
  name = var.cloudflare_domain
}

resource "cloudflare_record" "record" {
  zone_id = data.cloudflare_zone.domain.id
  name    = "gitops"
  value   = var.cloudflare_dns_address
  type    = "A"
  proxied = false
}
