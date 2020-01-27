module Harvesting
  module Models
    class Tasks < HarvestRecordCollection

      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs.reject {|k,v| k == "tasks" }, query_opts, opts)
        @entries = attrs["tasks"].map do |entry|
          Task.new(entry, harvest_client: opts[:harvest_client])
        end
      end

      def fetch_next_page
        @entries += harvest_client.tasks(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end
    end
  end
end
