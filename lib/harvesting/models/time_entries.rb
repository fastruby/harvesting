module Harvesting
  module Models
    class TimeEntries < HarvestRecordCollection

      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs.reject {|k,v| k == "time_entries" }, query_opts, opts)
        @entries = attrs["time_entries"].map do |entry|
          TimeEntry.new(entry, harvest_client: opts[:harvest_client])
        end
      end

      def fetch_next_page
        @entries += harvest_client.time_entries(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end
    end
  end
end
