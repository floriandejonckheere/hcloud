# frozen_string_literal: true

require "yaml"

module HCloud
  module MimeType
    class YAML < ::HTTP::MimeType::Adapter
      def encode(obj)
        return obj.to_yaml if obj.respond_to?(:to_yaml)

        ::YAML.dump(obj)
      end

      # Decodes JSON
      def decode(str)
        ::YAML.safe_load(str)
      end
    end
  end
end

HTTP::MimeType.register_adapter "application/x-yaml", HCloud::MimeType::YAML
HTTP::MimeType.register_alias "application/x-yaml", :yaml
