module Harvesting
  module Models
    class Client < HarvestRecord
      attributed :id,
                 :name,
                 :is_active,
                 :address,
                 :created_at,
                 :updated_at,
                 :currency

      def path
        id.nil? ? "clients" : "clients/#{id}"
      end
    end
  end
end
