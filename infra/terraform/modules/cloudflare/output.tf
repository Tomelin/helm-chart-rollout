output "cloudflare_dns_address" {
  value = cloudflare_record.record.content
}

output "cloudflare_dns_fqdn" {
  value = cloudflare_record.record.hostname
}

output "cloudflare_dns_record" {
  description = "teste"
  value       = cloudflare_record.record.name
}
