# frozen_string_literal: true

module HCloud
  class Resource
    include ActiveModel::Attributes

    protected

    def client
      HCloud::Client.connection
    end
  end
end
