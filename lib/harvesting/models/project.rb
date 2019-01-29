module Harvesting
  module Models
    # A project record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/projects-api/projects/projects/
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
        @attributes['id'].nil? ? "projects" : "projects/#{@attributes['id']}"
      end
      
      def to_hash
        { client_id: client.id }.merge(super)
      end

      def time_entries
        harvest_client.time_entries(project_id: self.id)
      end

      # Provides access to the user assignments that are associated with this
      # project.
      def user_assignments
        harvest_client.user_assignments(project_id: self.id)
      end

      # Provides access to the task assignments that are associated with this
      # project.
      def task_assignments
        harvest_client.task_assignments(project_id: self.id)
      end
    end
  end
end
