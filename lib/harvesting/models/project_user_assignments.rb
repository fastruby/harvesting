module Harvesting
  module Models
    class ProjectUserAssignments < HarvestRecordCollection

      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs.reject {|k,v| k == "user_assignments" }, query_opts, opts)
        @entries = attrs["user_assignments"].map do |entry|
          ProjectUserAssignment.new(entry, harvest_client: opts[:harvest_client])
        end
      end

      def fetch_next_page
        @entries += harvest_client.user_assignments(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end

    end
  end
end
