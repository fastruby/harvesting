module Harvesting
  module Models
    class Invoices < HarvestRecordCollection
      def initialize(attrs, query_opts = {}, opts = {})
        super(attrs.reject {|k,v| k == "invoices" }, query_opts, opts)
        @entries = attrs["invoices"].map do |entry|
          Invoice.new(entry, client: opts[:client])
        end
      end

      private
      
      def fetch_next_page
        @entries += harvest_client.invoices(next_page_query_opts).entries
        @attributes['page'] = page + 1
      end

    end
  end
end