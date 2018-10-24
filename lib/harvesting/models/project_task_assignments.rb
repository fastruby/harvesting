module Harvesting
  module Models
    class ProjectTaskAssignments < Base
      include Harvesting::Enumerable
      extend Forwardable

      attributed :per_page,
                 :total_pages,
                 :total_entries,
                 :next_page,
                 :previous_page,
                 :page,
                 :links

      def initialize(ref_project, attrs, opts = {})
        super(attrs.reject {|k,v| k == "task_assignments" }, opts)
        @ref_project = ref_project
        @api_page = attrs
        @entries = attrs["task_assignments"].map do |entry|
          ProjectTaskAssignment.new(ref_project, entry, client: opts[:client])
        end
      end

      def page
        @attributes['page']
      end

      def size
        total_entries
      end

      def fetch_next_page
        new_page = page + 1
        @entries += client.task_assignments(@ref_project, page: new_page).entries
        @attributes['page'] = new_page
      end
    end
  end
end
