module Harvesting
  module Models
    class TaskAssignment < Base
      attributed :id,
                 :is_active,
                 :billable,
                 :hourly_rate,
                 :budget,
                 :created_at,
                 :updated_at

      def project_id
        # TODO: handle case where project's id is part of json object
        @attributes["project_id"]
      end

      def path
        base_url = "projects/#{project_id}/task_assignments"
        id.nil? ? base_url : "#{base_url}/#{id}"
      end
    end
  end
end
