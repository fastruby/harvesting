module Harvesting
  module Models
    # A task assignment record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/projects-api/projects/task-assignments/
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

      private

      def path
        base_url = "projects/#{project.id}/task_assignments"
        id.nil? ? base_url : "#{base_url}/#{id}"
      end
    end
  end
end
