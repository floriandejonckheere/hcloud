# frozen_string_literal: true

HCloud.loader.inflector.inflect(
  "dns_pointer" => "DNSPointer",
  "hcloud" => "HCloud",
  "ssh_key" => "SSHKey",
  "floating_ip" => "FloatingIP",
  "floating_ip_price" => "FloatingIPPrice",
  "floating_ips" => "FloatingIPs",
  "floating_ip_prices" => "FloatingIPPrices",
  "http" => "HTTP",
  "ipv4" => "IPv4",
  "ipv6" => "IPv6",
  "ip_not_available" => "IPNotAvailable",
  "iso" => "ISO",
  "iso_type" => "ISOType",
)

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "DNS"
  inflect.acronym "JSON"
  inflect.acronym "IP"
  inflect.acronym "ISO"
end
