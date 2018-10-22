module Harvesting
  module Models
    class ProjectUserAssignments < Base
      include Harvesting::Enumerable
      extend Forwardable

      attributed :id,
                 :project,
                 :user,
                 :is_active,
                 :is_project_manager,
                 :hourly_rate,
                 :budget,
                 :created_at,
                 :updated_at

      def initialize(ref_project, attrs, opts = {})
        super(attrs.reject {|k,v| k == "user_assignments" }, opts)
        @api_page = attrs
        @entries = attrs["user_assignments"].map do |entry|
          ProjectUserAssignment.new(ref_project, entry, client: opts[:client])
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
        @entries += client.users(page: new_page).entries
        @attributes['page'] = new_page
      end
    end
  end
end
