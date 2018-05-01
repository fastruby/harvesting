require "byebug"
require "net/http"
require "json"

module Harvesting
  class Client
    DEFAULT_HOST = "https://api.harvestapp.com/v2"

    def initialize(access_token:, account_id:)
      @access_token = access_token
      @account_id = account_id
    end

    def me
      Harvesting::Models::User.new(get("users/me"), client: self)
    end

    def clients
      get("clients")["clients"].map do |result|
        Harvesting::Models::Client.new(result, client: self)
      end
    end

    def contacts
      get("contacts")["contacts"].map do |result|
        Harvesting::Models::Contact.new(result, client: self)
      end
    end

    def time_entries(opts = {})
      Harvesting::Models::TimeEntries.new get("time_entries", opts), client: self
    end

    private

    def get(path, opts = {})
      url = "#{DEFAULT_HOST}/#{path}"
      url += "?#{opts.map {|k, v| "#{k}=#{v}"}.join("&")}" if opts.any?
      uri = URI(url)
      response = nil

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Get.new uri
        request["User-Agent"] = "Ruby Harvest API Sample"
        request["Authorization"] = "Bearer #{@access_token}"
        request["Harvest-Account-ID"] = @account_id

        response = http.request request
      end

      raise Harvesting::AuthenticationError.new(response.body) if response.code.to_i >= 400
      JSON.parse(response.body)
    end
  end
end
