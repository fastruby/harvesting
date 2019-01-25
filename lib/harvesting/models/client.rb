module Harvesting
  module Models
    # A client record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/clients-api/clients/clients/
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
