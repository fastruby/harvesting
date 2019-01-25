module Harvesting
  module Models
    class Projects < HarvestRecordCollection

      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs.reject {|k,v| k == "projects" }, query_opts, opts)
        @entries = attrs["projects"].map do |entry|
          Project.new(entry, client: opts[:client])
        end
      end

      private
      
      def fetch_next_page
        @entries += harvest_client.projects(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end
    end
  end
end
