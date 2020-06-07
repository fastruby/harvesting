module Harvesting
  module Models
    class Clients < HarvestRecordCollection

      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs.reject {|k,v| k == "clients" }, query_opts, opts)
        @entries = attrs["clients"].map do |entry|
          Harvesting::Models::Client.new(entry, harvest_client: opts[:harvest_client])
        end
      end

      def fetch_next_page
        @entries += harvest_client.clients(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end
    end
  end
end
