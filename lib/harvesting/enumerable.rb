# `Enumerable` extends the stdlib `Enumerable` to provide pagination for paged
# API requests.
#
# @see https://github.com/sferik/twitter/blob/aa909b3b7733ca619d80f1c8cba961033d1fc7e6/lib/twitter/enumerable.rb
module Harvesting
  module Enumerable
    include ::Enumerable

    # @return [Enumerator]
    def each(start = 0, &block)
      @cursor = start
      return to_enum(:each, start) unless block_given?
      Array(@entries[start..-1]).each_with_index do |element, index|
        @cursor = index
        yield(element)
      end

      unless last?
        start = [@entries.size, start].max
        fetch_next_page
        each(start, &block)
      end
      self
    end

  private

    # @return [Boolean]
    def last?
      (((page - 1) * per_page) + @cursor) >= (total_entries - 1)
    end
  end
end
