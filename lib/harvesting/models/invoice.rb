module Harvesting
  module Models
    # An invoice record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/invoices-api/invoices/invoices/
    class Invoice < HarvestRecord
      attributed :id,
                 :client_key,
                 :number,
                 :purchase_order,
                 :amount,
                 :due_amount,
                 :tax,
                 :tax_amount,
                 :tax2,
                 :tax2_amount,
                 :discount,
                 :discount_amount,
                 :subject,
                 :notes,
                 :currency,
                 :state,
                 :period_start,
                 :period_end,
                 :issue_date,
                 :due_date,
                 :payment_term,
                 :sent_at,
                 :paid_at,
                 :paid_date,
                 :closed_at,
                 :created_at,
                 :updated_at

      def line_items
        @line_items ||= @attributes['line_items'].map { |line_item_attributes| LineItem.new line_item_attributes, { harvest_client: harvest_client } }
      end

      def path
        @attributes['id'].nil? ? "invoices" : "invoices/#{@attributes['id']}"
      end
    end
  end
end
