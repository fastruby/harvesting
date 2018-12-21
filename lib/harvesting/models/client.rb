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
        @attributes['id'].nil? ? "clients" : "clients/#{@attributes['id']}"
      end
    end
  end
end
