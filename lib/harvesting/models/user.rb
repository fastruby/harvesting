module Harvesting
  module Models
    class User < HarvestRecord
      attributed :id,
                 :first_name,
                 :last_name,
                 :email,
                 :telephone,
                 :timezone,
                 :weekly_capacity,
                 :has_access_to_all_future_projects,
                 :is_contractor,
                 :is_admin,
                 :is_project_manager,
                 :can_see_rates,
                 :can_create_projects,
                 :can_create_invoices,
                 :is_active,
                 :created_at,
                 :updated_at,
                 :roles,
                 :avatar_url

      def path
        id.nil? ? "users" : "users/#{id}"
      end
    end
  end
end
