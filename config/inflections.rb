# frozen_string_literal: true

HCloud.loader.inflector.inflect(
  "hcloud" => "HCloud",
  "ssh_key" => "SSHKey",
  "http" => "HTTP",
  "iso" => "ISO",
)

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "JSON"
  inflect.acronym "ISO"
end
