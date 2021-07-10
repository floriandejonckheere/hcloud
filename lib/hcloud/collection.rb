# frozen_string_literal: true

module HCloud
  class Collection
    include Enumerable

    attr_accessor :page, :previous_page, :next_page, :last_page, :per_page, :total_entries, :proc

    def initialize(&block)
      @proc = block

      @page = 1
      @per_page = 50
    end

    def each(&block)
      return to_enum(:each) unless block

      loop do
        # Fetch page
        data, meta = proc.call(page: page, per_page: per_page)

        # Yield data in page
        data.each(&block)

        # Set cursor and other page attributes
        meta[:pagination].each { |k, v| send(:"#{k}=", v) }

        break if page == last_page

        # Increment page
        @page += 1
      end
    end

    def count
      # Fetch total_entries if not present
      @count ||= (total_entries || proc.call(page: 1, per_page: per_page).last.dig(:pagination, :total_entries))
    end
  end
end
