# frozen_string_literal: true

HCloud.loader.inflector.inflect(
  "hcloud" => "HCloud",
  "ssh_key" => "SSHKey",
  "http" => "HTTP",
  "iso" => "ISO",
  "iso_type" => "ISOType",
)

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "JSON"
  inflect.acronym "ISO"
end
