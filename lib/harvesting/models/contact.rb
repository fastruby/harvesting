module Harvesting
  module Models
    class Contact < Base
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

      def path
        id.nil? ? "contacts" : "contacts/#{id}"
      end

      def client
        @client = Client.new(@attributes["client"], client: harvest_client)
      end
    end
  end
end
