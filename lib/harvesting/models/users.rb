module Harvesting
  module Models
    class Users < Base
      include Harvesting::Enumerable
      extend Forwardable

      attributed :is_active,
                 :total_pages,
                 :total_entries,
                 :next_page,
                 :previous_page,
                 :page,
                 :links

      attr_reader :entries

      def initialize(attrs, opts = {})
        super(attrs.reject {|k,v| k == "users" }, opts)
        @api_page = attrs
        @entries = attrs["users"].map do |entry|
          User.new(entry, client: opts[:client])
        end
      end

      # def each
      #   @entries.each_with_index do |user, index|
      #     yield(user)
      #   end
      # end
      def page
        @attributes['page']
      end

      def size
        total_entries
      end

      def fetch_next_page
        new_page = page + 1
        @entries += client.users(page: new_page).entries
        @attributes['page'] = new_page
      end
    end
  end
end
