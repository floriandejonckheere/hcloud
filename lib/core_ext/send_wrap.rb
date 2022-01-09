# frozen_string_literal: true

module CoreExt
  module SendWrap
    # Send a message to self, or all objects contained in self (for enumerables)
    def send_wrap(method_name, ...)
      # For hashes, send_wrap should map only the values
      method = is_a?(Hash) ? :transform_values : :map

      respond_to?(:each) ? send(method) { |o| o.send(method_name, ...) } : send(method_name, ...)
    end
  end
end

Object.include CoreExt::SendWrap
