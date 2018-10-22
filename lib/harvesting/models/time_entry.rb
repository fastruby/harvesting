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
                 :billable,
                 :budgeted,
                 :billable_rate,
                 :cost_rate,
                 :task_id,
                 {
                  external_reference: [
                    :id,
                    :group_id,
                    :permalink
                  ]
                 },
                 {
                  invoice: [
                    :id,
                    :number
                  ]
                 },
                 {
                  user: [
                    :id,
                    :name
                  ]
                 },
                 {
                  user_assignment: [
                    :id,
                    :is_project_manager,
                    :is_active,
                    :budget,
                    :hourly_rate,
                    :created_at,
                    :updated_at
                  ]
                 },
                 {
                  client: [
                    :id,
                    :name
                  ]
                 },
                 {
                  task: [
                    :id,
                    :name
                  ]
                 },
                 {
                  task_assignment: [
                    :id,
                    :billable,
                    :is_active,
                    :hourly_rate,
                    :budget,
                    :created_at,
                    :updated_at
                  ]
                 },
                 {
                  project: [
                    :name,
                    :id
                  ]
                 }

      def path
        id.nil? ? "time_entries" : "time_entries/#{id}"
      end

      def user
        Models::User.new(@attributes['user'], client: @client)
      end
    end
  end
end
