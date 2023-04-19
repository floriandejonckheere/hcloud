# frozen_string_literal: true

module HCloud
  class Collection
    include Enumerable

    attr_accessor :page, :previous_page, :next_page, :last_page, :per_page, :total_entries, :proc

    attr_reader :sort_by, :filter_by, :label_selector

    def initialize(&block)
      @proc = block

      @page = 1
      @per_page = 50

      @sort_by = nil
      @filter_by = {}
    end

    def sort(*sort_by)
      @sort_by = sort_by

      self
    end

    def where(label_selector: nil, **filter_by)
      @filter_by = filter_by
      @label_selector = label_selector

      self.select do |resource|
        filter_by.all? { |k, v| resource[k.to_s] == v }
      end
    end

    def each(&block)
      return to_enum(:each) unless block

      loop do
        # Fetch page
        data, meta = proc.call(params)

        # Yield data in page
        data.each(&block)

        # Set cursor and other page attributes
        meta[:pagination].each { |k, v| send(:"#{k}=", v) }

        break if page == last_page

        # Increment page
        @page += 1
      end

      self
    end

    def count
      # Fetch total_entries if not present
      @count ||= (total_entries || proc.call(params.merge(page: 1)).last.dig(:pagination, :total_entries))
    end

    def empty?
      count.zero?
    end

    delegate :[], :last, to: :to_a

    private

    def params
      {
        page: page,
        per_page: per_page,
        sort: sort_by,
        label_selector: label_selector&.map { |k, v| "#{k}=#{v}" }&.join(","),
        **filter_by,
      }
    end
  end
end
