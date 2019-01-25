module Harvesting
  module Models
    # An user record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/users-api/users/users/
    class User < HarvestRecord
      attributed :id,
                 :name,
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
        @attributes['id'].nil? ? "users" : "users/#{@attributes['id']}"
      end

      def name
        @attributes['name'].nil? ? "#{first_name} #{last_name}" : @attributes['name']
      end
    end
  end
end
