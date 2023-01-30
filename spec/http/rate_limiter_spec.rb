# frozen_string_literal: true

# rubocop:disable RSpec/SubjectStub
RSpec.describe HTTP::RateLimiter do
  subject(:rate_limiter) { http.default_options.features.fetch(:rate_limiter) }

  let(:http) { HTTP.use(:rate_limiter) }

  before { allow(rate_limiter).to receive(:sleep) { |s| Timecop.travel(s) } }

  describe "when rate limit is not exceeded" do
    it "immediately executes the request" do
      stub_request(:get, "https://endpoint/api")
        .to_return(status: 200, headers: headers(limit: 100, remaining: 99, reset: 1_234_567_890, date: Time.at(0)))

      # Execute twice: first for analysis, second for actual request
      2.times { http.get("https://endpoint/api") }

      expect(rate_limiter).not_to have_received(:sleep)
    end

    it "analyzes the response" do
      stub_request(:get, "https://endpoint/api")
        .to_return(status: 200, headers: headers(limit: 100, remaining: 99, reset: 1_234_567_890, date: Time.at(0)))

      http
        .get("https://endpoint/api")

      expect(rate_limiter.limit).to eq 100
      expect(rate_limiter.remaining).to eq 99
      expect(rate_limiter.reset).to eq Time.at(1_234_567_890)
      expect(rate_limiter.at).to eq Time.at(0)
    end
  end

  describe "when rate limit is exceeded" do
    before { Timecop.freeze }

    it "executes the request when the remaining requests are incremented" do
      stub_request(:get, "https://endpoint/api")
        .to_return(status: 200, headers: headers(limit: 100, remaining: 0, reset: 1.hour.from_now, date: Time.now))

      # Execute twice: first for analysis, second for actual request
      2.times { http.get("https://endpoint/api") }

      # Rate of increment = 3600 / 100 = 36 seconds
      expect(rate_limiter).to have_received(:sleep).with(36)
    end

    it "analyzes the response" do
      stub_request(:get, "https://endpoint/api")
        .to_return(status: 200, headers: headers(limit: 100, remaining: 0, reset: 1.hour.from_now, date: Time.now))

      http
        .get("https://endpoint/api")

      expect(rate_limiter.limit).to eq 100
      expect(rate_limiter.remaining).to eq 0
      expect(rate_limiter.reset).to be_within(1.second).of 1.hour.from_now
      expect(rate_limiter.at).to be_within(1.second).of Time.now
    end
  end

  def headers(limit:, remaining:, reset:, date:)
    {
      "RateLimit-Limit" => limit.to_s,
      "RateLimit-Remaining" => remaining.to_s,
      "RateLimit-Reset" => reset.to_i,
      "Date" => date.iso8601,
    }
  end
end
# rubocop:enable RSpec/SubjectStub
