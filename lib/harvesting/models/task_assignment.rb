require 'pry'

module Harvesting
  module Models
    class TaskAssignment < HarvestRecord
      attributed :id,
                 :is_active,
                 :billable,
                 :hourly_rate,
                 :budget,
                 :created_at,
                 :updated_at

      modeled project: Project,
              task: Task

      def path
        base_url = "projects/#{project.id}/task_assignments"
        id.nil? ? base_url : "#{base_url}/#{id}"
      end

      # def project_id
      #   # TODO: handle case where project's id is part of json object
      #   @attributes["project_id"]
      # end

    end
  end
end
