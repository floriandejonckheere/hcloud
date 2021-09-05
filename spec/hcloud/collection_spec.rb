# frozen_string_literal: true

RSpec.describe HCloud::Collection do
  subject(:collection) { described_class.new { |params| proc(params) } }

  describe "#each" do
    it "iterates over the pages" do
      expect { |block| collection.each(&block) }.to yield_control.exactly(175).times
    end

    context "when given a block" do
      it "returns the collection" do
        expect(collection.each(&:to_s)).to eq collection
      end
    end

    context "when given no arguments" do
      it "returns an enumerator" do
        expect(collection.each).to be_a Enumerator
      end
    end
  end

  describe "#count" do
    it "returns the total length" do
      expect(collection.count).to eq 175
    end
  end

  describe "#empty?" do
    it "returns false" do
      expect(collection).not_to be_empty
    end
  end

  def proc(params)
    page = {
      1 => (0..49),
      2 => (50..99),
      3 => (100..149),
      4 => (150..174),
    }[params[:page]]

    data = page.map { |i| "Data #{i}" }
    meta = {
      pagination: {
        page: params[:page],
        per_page: params[:per_page],
        previous_page: [params[:page] - 1, 1].max,
        next_page: [4, params[:page] + 1].min,
        last_page: 4,
        total_entries: 175,
      },
    }

    [data, meta]
  end
end
