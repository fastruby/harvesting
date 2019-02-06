module Harvesting
  module Models
    class ProjectUserAssignment < HarvestRecord
      attributed :id,
                 :is_active,
                 :is_project_manager,
                 :hourly_rate,
                 :budget,
                 :created_at,
                 :updated_at

      modeled project: Project,
              user: User

      def path
        base_url = "projects/#{project.id}/user_assignments"
        @attributes['id'].nil? ? base_url : "#{base_url}/#{@attributes['id']}"
      end

      def to_hash
        { project_id: project.id, user_id: user.id }.merge(super)
      end
    end
  end
end
