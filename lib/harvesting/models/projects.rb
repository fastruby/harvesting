module Harvesting
  module Models
    class Projects < Base
      include Harvesting::Enumerable
      extend Forwardable

      attributed :per_page,
                 :total_pages,
                 :total_entries,
                 :next_page,
                 :previous_page,
                 :page,
                 :links

      attr_reader :entries

      def initialize(attrs, opts = {})
        super(attrs.reject {|k,v| k == "projects" }, opts)
        @api_page = attrs
        @entries = attrs["projects"].map do |entry|
          Project.new(entry, client: opts[:client])
        end
      end

      # def each
      #   @entries.each_with_index do |time_entry, index|
      #     yield(time_entry)
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
        @entries += harvest_client.projects(page: new_page).entries
        @attributes['page'] = new_page
      end
    end
  end
end
