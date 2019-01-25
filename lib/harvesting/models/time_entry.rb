module Harvesting
  module Models
    # A time entry record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/timesheets-api/timesheets/time-entries/
    class TimeEntry < HarvestRecord
      attributed :id,
                 :spent_date,
                 :hours,
                 :notes,
                 :is_locked,
                 :locked_reason,
                 :is_closed,
                 :is_billed,
                 :timer_started_at,
                 :started_time,
                 :ended_time,
                 :is_running,
                 :billable,
                 :budgeted,
                 :billable_rate,
                 :cost_rate,
                 :invoice,
                 :external_reference,
                 :created_at,
                 :updated_at

      modeled project: Project,
              user: User,
              task: Task,
              client: Client,
              task_assignment: ProjectTaskAssignment,
              user_assignment: ProjectUserAssignment


      def path
        @attributes['id'].nil? ? "time_entries" : "time_entries/#{@attributes['id']}"
      end

      def to_hash
        { project_id: project.id, task_id: task.id, user_id: user.id }.merge(super)
      end

    end
  end
end
