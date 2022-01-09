# frozen_string_literal: true

module CoreExt
  module SendWrap
    # Send a message to self, or all objects contained in self (for enumerables)
    def send_wrap(method_name, ...)
      respond_to?(:each) ? map { |o| o.send(method_name, ...) } : send(method_name, ...)
    end
  end
end

Object.include CoreExt::SendWrap
