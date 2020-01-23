module Harvesting
  module Models
    class ProjectTaskAssignments < HarvestRecordCollection
      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs.reject {|k,v| k == "task_assignments" }, query_opts, opts)
        @entries = attrs["task_assignments"].map do |entry|
          ProjectTaskAssignment.new(entry, harvest_client: opts[:harvest_client])
        end
      end

      def fetch_next_page
        @entries += harvest_client.task_assignments(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end

    end
  end
end
