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
        @attributes['id'].nil? ? "contacts" : "contacts/#{@attributes['id']}"
      end
    end
  end
end
