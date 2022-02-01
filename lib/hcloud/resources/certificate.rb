# frozen_string_literal: true

module HCloud
  ##
  # Represents a certificate
  #
  # == List all certificates
  #
  #     HCloud::Certificate.all
  #     # => [#<HCloud::Certificate id: 1, ...>, ...]
  #
  # == Sort certificates
  #
  #     HCloud::Certificate.all.sort(name: :desc)
  #     # => [#<HCloud::Certificate id: 1, ...>, ...]
  #
  #     HCloud::Certificate.all.sort(:id, name: :asc)
  #     # => [#<HCloud::Certificate id: 1, ...>, ...]
  #
  # == Search certificates
  #
  #     HCloud::Certificate.all.where(name: "my_certificate")
  #     # => #<HCloud::Certificate id: 1, ...>
  #
  #     HCloud::Certificate.all.where(type: "uploaded")
  #     # => #<HCloud::Certificate id: 1, ...>
  #
  # == Find certificate by ID
  #
  #     HCloud::Certificate.find(1)
  #     # => #<HCloud::Certificate id: 1, ...>
  #
  # == Create certificate
  #
  #     certificate = HCloud::Certificate.new(name: "my_certificate", type: "managed", domain_names: ["example.com"])
  #     certificate.create
  #     certificate.created?
  #     # => true
  #
  #     certificate = HCloud::Certificate.create(name: "my_certificate", type: "managed", domain_names: ["example.com"])
  #     # => #<HCloud::Certificate id: 1, ...>
  #
  # == Update certificate
  #
  #     certificate = HCloud::Certificate.find(1)
  #     certificate.name = "another_certificate"
  #     certificate.update
  #
  # == Delete certificate
  #
  #     certificate = HCloud::Certificate.find(1)
  #     certificate.delete
  #     certificate.deleted?
  #     # => true
  #
  # = Actions
  # == List actions
  #
  #     actions = HCloud::Certificate.find(1).actions
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  # == Sort actions
  #
  #     HCloud::Certificate.find(1).actions.sort(finished: :desc)
  #     # => [#<HCloud::Action id: 1, ...>, ...]
  #
  #     HCloud::Certificate.find(1).actions.sort(:command, finished: :asc)
  #     # => [#<HCloud::Actions id: 1, ...>, ...]
  #
  # == Search actions
  #
  #     HCloud::Certificate.find(1).actions.where(command: "set_rules")
  #     # => #<HCloud::Action id: 1, ...>
  #
  #     HCloud::Certificate.find(1).actions.where(status: "success")
  #     # => #<HCloud::Action id: 1, ...>
  #
  # == Find action by ID
  #
  #     HCloud::Certificate.find(1).actions.find(1)
  #     # => #<HCloud::Action id: 1, ...>
  #
  # = Resource-specific actions
  # == Retry issuance or renewal
  #
  #     certificate = HCloud::Certificate.find(1)
  #
  #     certificate.retry
  #     # => #<HCloud::Action ...>
  #
  class Certificate < Resource
    actionable
    queryable
    creatable
    updatable
    deletable

    attribute :id, :integer
    attribute :name

    attribute :type

    attribute :certificate
    attribute :fingerprint

    # TODO: use only for creation
    attribute :private_key

    attribute :not_valid_before, :datetime
    attribute :not_valid_after, :datetime

    attribute :domain_names, array: true, default: -> { [] }

    attribute :status, :certificate_status

    # TODO: dynamically return resource classes
    attribute :used_by, :used_by, array: true, default: -> { [] }

    attribute :labels, default: -> { {} }

    action :retry

    def creatable_attributes
      [:name, :labels, :type, :private_key, :certificate, :domain_names]
    end

    def updatable_attributes
      [:name, :labels]
    end
  end
end
