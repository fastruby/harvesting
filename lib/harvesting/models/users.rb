module Harvesting
  module Models
    class Users < HarvestRecordCollection

      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs.reject {|k,v| k == "users" }, query_opts, opts)
        @entries = attrs["users"].map do |entry|
          User.new(entry, harvest_client: opts[:harvest_client])
        end
      end

      def fetch_next_page
        @entries += harvest_client.users(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end
    end
  end
end
