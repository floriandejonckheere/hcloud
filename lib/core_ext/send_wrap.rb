# frozen_string_literal: true

# @!visibility private
module CoreExt
  # @!visibility private
  module SendWrap
    # Send a message to self, or all objects contained in self (for arrays)

    # NOTE: { env: "prod" }.send_wrap(:try, :to_h) returns { env: nil }
    # NOTE: ["example.com"].send_wrap(:try, to_h) return [nil]
    # Use a block for the above cases:
    # { env: "prod" }.send_wrap { |o| o.try(:to_h) || o }

    def send_wrap(...)
      if is_a?(Array)
        map { |v| block_given? ? yield(v) : v.send(...) }
      else
        block_given? ? yield(self) : send(...)
      end
    end
  end
end

Object.include CoreExt::SendWrap
