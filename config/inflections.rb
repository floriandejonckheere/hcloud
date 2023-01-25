# frozen_string_literal: true

HCloud.loader.inflector.inflect(
  "dns_pointer" => "DNSPointer",
  "floating_ip" => "FloatingIP",
  "floating_ip_price" => "FloatingIPPrice",
  "floating_ip_prices" => "FloatingIPPrices",
  "floating_ips" => "FloatingIPs",
  "hcloud" => "HCloud",
  "health_check_http" => "HealthCheckHTTP",
  "http" => "HTTP",
  "ip_not_available" => "IPNotAvailable",
  "ipv4" => "IPv4",
  "ipv6" => "IPv6",
  "iso" => "ISO",
  "iso_type" => "ISOType",
  "primary_ip" => "PrimaryIP",
  "primary_ip_prices" => "PrimaryIPPrices",
  "service_http" => "ServiceHTTP",
  "ssh_key" => "SSHKey",
  "target_ip" => "TargetIP",
  "yaml" => "YAML",
)

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "DNS"
  inflect.acronym "HTTP"
  inflect.acronym "IP"
  inflect.acronym "IPv4"
  inflect.acronym "IPv6"
  inflect.acronym "ISO"
  inflect.acronym "JSON"
  inflect.acronym "YAML"
end
