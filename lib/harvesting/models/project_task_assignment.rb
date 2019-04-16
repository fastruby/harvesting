module Harvesting
  module Models
    # A task assignment record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/projects-api/projects/task-assignments/
    class ProjectTaskAssignment < HarvestRecord
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
      
      def to_hash
        { project_id: project.id, task_id: task.id }.merge(super)
      end
    end
  end
end
