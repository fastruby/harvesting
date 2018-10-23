module Harvesting
  module Models
    class TimeEntries < Base
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
        super(attrs.reject {|k,v| k == "time_entries" }, opts)
        @query_opts = query_opts
        @api_page = attrs
        @entries = attrs["time_entries"].map do |entry|
          TimeEntry.new(entry, client: opts[:client])
        end
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
        @entries += harvest_client.time_entries(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end
    end
  end
end
