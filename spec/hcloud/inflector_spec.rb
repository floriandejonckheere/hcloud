# frozen_string_literal: true

RSpec.describe HCloud::Inflector do
  subject(:inflector) { described_class.new }

  describe "#camelize" do
    it "camelizes filenames" do
      expect(inflector.camelize("load_balancer", nil)).to eq "LoadBalancer"

      # Zeitwerk by default does not handle slashes in camelize
      # expect(inflector.camelize("cloud/load_balancer", nil)).to eq "Cloud::LoadBalancer"
    end

    it "respects overrides" do
      inflector.inflect("ssh_key" => "SSHKey")

      expect(inflector.camelize("ssh_key", nil)).to eq "SSHKey"

      # Zeitwerk by default does not handle slashes in camelize
      # expect(inflector.camelize("cloud/ssh_key", nil)).to eq "Cloud::SSHKey"
    end
  end

  describe "#underscore" do
    it "underscores class names" do
      expect(inflector.underscore("LoadBalancer")).to eq "load_balancer"
      expect(inflector.underscore("Cloud::LoadBalancer")).to eq "cloud/load_balancer"
    end

    it "respects overrides" do
      inflector.inflect("ssh_key" => "SSHKey")

      expect(inflector.underscore("SSHKey")).to eq "ssh_key"
      expect(inflector.underscore("Cloud::SSHKey")).to eq "cloud/ssh_key"
    end
  end
end
