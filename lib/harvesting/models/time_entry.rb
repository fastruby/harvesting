module Harvesting
  module Models
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
                 :updated_at,
                 :user_assignment # temporarily return the hash itself until the model is added

      modeled project: Project,
              user: User,
              task: Task,
              client: Client,
              task_assignment: TaskAssignment


      def path
        @attributes['id'].nil? ? "time_entries" : "time_entries/#{@attributes['id']}"
      end

    end
  end
end
