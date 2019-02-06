module Harvesting
  module Models
    # An invoice record from your Harvest account.
    #
    # For more information: https://help.getharvest.com/api-v2/invoices-api/invoices/invoices/
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
                 :updated_at,
                 :time,
                 :expenses

      modeled client: Client

      def creator
        @harvest_client.me
      end

      def path
        @attributes['id'].nil? ? "invoices" : "invoices/#{@attributes['id']}"
      end

      def to_hash
        base_hash = { "client_id" => client.id }.merge(super)
        line_item_projects.empty? ? base_hash : line_items_hash(base_hash)
      end

      def line_item_projects
        @attributes['line_items'].nil? ? [] : @attributes['line_items'].reject{ |line_item| line_item['project'].nil? }
      end

      def line_items_hash(base_hash)
        base_hash.delete("line_items")
        base_hash.merge({ "line_items_import" => line_items_import })
      end

      def line_items_import
        project_ids = line_item_projects.map{ |line_item| line_item['project']['id'] }
        { 
          "project_ids" => project_ids,
          "time" => time_import_params,
          "expenses" => expense_import_params
        }
      end

      def time_import_params
        @attributes['time'].nil? ? { "summary_type" => "task"} : @attributes['time']
      end

      def expense_import_params
        @attributes['expenses'].nil? ? { "summary_type" => "category" } : @attributes['expenses']
      end
    end
  end
end
