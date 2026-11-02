# frozen_string_literal: true

RSpec.describe HCloud::Errors do
  describe ".for" do
    it "looks up error classes" do
      expect(described_class.for("invalid_input")).to eq HCloud::Errors::InvalidInput
      expect(described_class.for("must_be_unassigned")).to eq HCloud::Errors::MustBeUnassigned
    end

    it "looks up error classes containing IP acronyms" do
      expect(described_class.for("ip_not_available")).to eq HCloud::Errors::IPNotAvailable
      expect(described_class.for("cloud_resource_ip_not_allowed")).to eq HCloud::Errors::CloudResourceIPNotAllowed
      expect(described_class.for("primary_ip_assigned")).to eq HCloud::Errors::PrimaryIPAssigned
      expect(described_class.for("primary_ip_blocked")).to eq HCloud::Errors::PrimaryIPBlocked
      expect(described_class.for("targets_without_use_private_ip")).to eq HCloud::Errors::TargetsWithoutUsePrivateIP
      expect(described_class.for("server_has_ipv4")).to eq HCloud::Errors::ServerHasIPv4
      expect(described_class.for("server_has_ipv6")).to eq HCloud::Errors::ServerHasIPv6
    end

    it "looks up error classes containing JSON acronym" do
      expect(described_class.for("json_error")).to eq HCloud::Errors::JSONError
    end
  end
end
