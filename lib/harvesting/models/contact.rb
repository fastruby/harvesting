module Harvesting
  module Models
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
        id.nil? ? "contacts" : "contacts/#{id}"
      end
    end
  end
end
