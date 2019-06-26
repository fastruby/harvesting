require 'forwardable'

module Harvesting
  module Models
    class HarvestRecordCollection < Base
      include Harvesting::Enumerable
      extend Forwardable

      attributed :per_page,
                 :total_pages,
                 :total_entries,
                 :next_page,
                 :previous_page,
                 :page,
                 :links

      attr_reader :entries

      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs, opts)
        @query_opts = query_opts
        @api_page = attrs
      end

      def page
        @attributes['page']
      end

      def size
        total_entries
      end

      def next_page_query_opts
        @query_opts.merge(page: page + 1)
      end

      def fetch_next_page
        raise NotImplementedError
      end

    end
  end
end
