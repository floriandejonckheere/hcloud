# frozen_string_literal: true

HCloud.loader.inflector.inflect(
  "dns_pointer" => "DNSPointer",
  "floating_ip" => "FloatingIP",
  "floating_ip_price" => "FloatingIPPrice",
  "floating_ip_prices" => "FloatingIPPrices",
  "floating_ips" => "FloatingIPs",
  "hcloud" => "HCloud",
  "http" => "HTTP",
  "ip_not_available" => "IPNotAvailable",
  "ipv4" => "IPv4",
  "ipv6" => "IPv6",
  "iso" => "ISO",
  "iso_type" => "ISOType",
  "ssh_key" => "SSHKey",
)

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "DNS"
  inflect.acronym "IP"
  inflect.acronym "ISO"
  inflect.acronym "JSON"
end
