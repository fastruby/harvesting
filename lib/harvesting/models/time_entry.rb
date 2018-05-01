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
                 :cost_rate

    end
  end
end
