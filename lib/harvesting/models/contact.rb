module Harvesting
  module Models
    # A contact record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/clients-api/clients/contacts/
    class Contact < HarvestRecord
      attributed :id,
                 :title,
                 :first_name,
                 :last_name,
                 :email,
                 :phone_office,
                 :phone_mobile,
                 :fax,
                 :created_at,
                 :updated_at

      modeled client: Client

      def path
        @attributes['id'].nil? ? "contacts" : "contacts/#{@attributes['id']}"
      end
      
      def to_hash
        { client_id: client.id }.merge(super)
      end
    end
  end
end
