module Harvesting
  module Models
    # A task record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/tasks-api/tasks/tasks/
    class Task < HarvestRecord
      attributed :id,
                 :name,
                 :billable_by_default,
                 :default_hourly_rate,
                 :is_default,
                 :is_active,
                 :created_at,
                 :updated_at

      def path
        @attributes['id'].nil? ? "tasks" : "tasks/#{@attributes['id']}"
      end
    end
  end
end
