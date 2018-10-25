module Harvesting
  module Models
    class User < HarvestRecord
      attributed :id,
                 :first_name,
                 :last_name,
                 :email,
                 :telephone,
                 :timezone,
                 :has_access_to_all_future_projects,
                 :is_contractor,
                 :is_admin,
                 :is_project_manager,
                 :can_see_rates,
                 :can_create_invoices,
                 :can_create_projects,
                 :is_active,
                 :weekly_capacity,
                 :default_hourly_rate,
                 :cost_rate,
                 :roles,
                 :avatar_url,
                 :created_at,
                 :updated_at

      def path
        id.nil? ? "users" : "users/#{id}"
      end
    end
  end
end
