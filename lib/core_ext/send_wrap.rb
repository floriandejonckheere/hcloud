# frozen_string_literal: true

module CoreExt
  module SendWrap
    # Send a message to self, or all objects contained in self (for enumerables)

    # FIXME: { env: "prod" }.send_wrap(:try, :to_h) returns { env: nil }

    def send_wrap(method_name, ...)
      is_a?(Array) ? map { |v| v.send(method_name, ...) } : send(method_name, ...)
    end
  end
end

Object.include CoreExt::SendWrap
