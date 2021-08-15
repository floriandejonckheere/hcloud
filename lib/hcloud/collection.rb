# frozen_string_literal: true

module HCloud
  class Collection
    include Enumerable

    attr_accessor :page, :previous_page, :next_page, :last_page, :per_page, :total_entries, :proc

    attr_reader :sort_by, :filter_by

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

    def where(**filter_by)
      @filter_by = filter_by

      self
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

    delegate :[], :last, to: :to_a

    private

    def params
      {
        page: page,
        per_page: per_page,
        sort: sort_by,
        **filter_by,
      }
    end
  end
end
