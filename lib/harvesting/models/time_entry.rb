module Harvesting
  module Models
    class TimeEntry < Base
      attributed :id,
                 :spent_date,
                 :hours,
                 :notes,
                 :created_at,
                 :updated_at,
                 :is_locked,
                 :locked_reason,
                 :is_closed,
                 :is_billed,
                 :timer_started_at,
                 :started_time,
                 :ended_time,
                 :is_running,
                 :invoice,
                 :external_reference,
                 :billable,
                 :budgeted,
                 :billable_rate,
                 :cost_rate,
                 :project_id,
                 :task_id

      def path
        id.nil? ? "time_entries" : "time_entries/#{id}"
      end

      def user
        Models::User.new(@attributes['user'], client: harvest_client)
      end

      def task
        Models::Task.new(@attributes['task'], client: harvest_client)
      end
    end
  end
end
