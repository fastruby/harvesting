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

      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs.reject {|k,v| k == "projects" }, opts)
        @query_opts = query_opts
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

      def next_page_query_opts
        @query_opts.merge(page: page + 1)
      end

      def fetch_next_page
        @entries += harvest_client.projects(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end
    end
  end
end
