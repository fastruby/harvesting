module Harvesting
  module Models
    class Invoice < HarvestRecord
      attributed :id,
                 :client_key,
                 :line_items,
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
      def path
        @attributes['id'].nil? ? "invoices" : "invoices/#{@attributes['id']}"
      end
    end
  end
end
