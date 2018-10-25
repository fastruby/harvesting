module Harvesting
  module Models
    class Project < HarvestRecord
      attributed :id,
                 :name,
                 :code,
                 :is_active,
                 :is_billable,
                 :is_fixed_fee,
                 :bill_by,
                 :hourly_rate,
                 :budget,
                 :budget_by,
                 :budget_is_monthly,
                 :notify_when_over_budget,
                 :over_budget_notification_percentage,
                 :over_budget_notification_date,
                 :show_budget_to_all,
                 :cost_budget,
                 :cost_budget_include_expenses,
                 :fee,
                 :notes,
                 :starts_on,
                 :ends_on,
                 :created_at,
                 :updated_at

      modeled client: Client

      def path
        id.nil? ? "projects" : "projects/#{id}"
      end
    end
  end
end
