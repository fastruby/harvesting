# frozen_string_literal: true
require "http"
require "json"

module Harvesting
  # A client for the Harvest API (version 2.0)
  class Client
    extend Harvesting::ActiveSupport::AttributeAccessors
    DEFAULT_HOST = "https://api.harvestapp.com/v2"

    mattr_accessor :access_token, :account_id

    def self.setup
      yield self
    end

    # Returns a new instance of `Client`
    #
    #     client = Client.new(access_token: "12345678", account_id: "98764")
    #
    # @param [Hash] opts the options to create an API client
    # @option opts [String] :access_token Harvest access token
    # @option opts [String] :account_id Harvest account id
    def initialize(access_token: ENV['HARVEST_ACCESS_TOKEN'], account_id: ENV['HARVEST_ACCOUNT_ID'])
      @access_token = @@access_token.to_s || access_token.to_s
      @account_id   = @@account_id.to_s || account_id.to_s

      if @account_id.length == 0 || @access_token.length == 0
        raise ArgumentError.new("Access token and account id are required. Access token: '#{@access_token}'. Account ID: '#{@account_id}'.")
      end
    end

    # @return [Harvesting::Models::User]
    def me
      Harvesting::Models::User.new(get("users/me"), harvest_client: self)
    end

    # @return [Harvesting::Models::Clients]
    def clients(opts = {})
      Harvesting::Models::Clients.new(get("clients", opts), opts, harvest_client: self)
    end

    # @return [Array<Harvesting::Models::Contact>]
    def contacts
      get("contacts")["contacts"].map do |result|
        Harvesting::Models::Contact.new(result, harvest_client: self)
      end
    end

    # @return [Harvesting::Models::TimeEntries]
    def time_entries(opts = {})
      Harvesting::Models::TimeEntries.new(get("time_entries", opts), opts, harvest_client: self)
    end

    # @return [Harvesting::Models::Projects]
    def projects(opts = {})
      Harvesting::Models::Projects.new(get("projects", opts), opts, harvest_client: self)
    end

    # @return [Harvesting::Models::Tasks]
    def tasks(opts = {})
      Harvesting::Models::Tasks.new(get("tasks", opts), opts, harvest_client: self)
    end

    # @return [Harvesting::Models::Users]
    def users(opts = {})
      Harvesting::Models::Users.new(get("users", opts), opts, harvest_client: self)
    end

    # @return [Array<Harvesting::Models::Invoice>]
    def invoices(opts = {})
      Harvesting::Models::Invoices.new(get("invoices", opts), opts, harvest_client: self)
    end

    # @return [Harvesting::Models::ProjectUserAssignments]
    def user_assignments(opts = {})
      project_id = opts.delete(:project_id)
      path = project_id.nil? ? "user_assignments" : "projects/#{project_id}/user_assignments"
      Harvesting::Models::ProjectUserAssignments.new(get(path, opts), opts, harvest_client: self)
    end

    # @return [Harvesting::Models::ProjectTaskAssignments]
    def task_assignments(opts = {})
      project_id = opts.delete(:project_id)
      path = project_id.nil? ? "task_assignments" : "projects/#{project_id}/task_assignments"
      Harvesting::Models::ProjectTaskAssignments.new(get(path, opts), opts, harvest_client: self)
    end

    # Creates an `entity` in your Harvest account.
    #
    # @param entity [Harvesting::Models::Base] A new record in your Harvest account
    # @return [Harvesting::Models::Base] A subclass of `Harvesting::Models::Base` updated with the response from Harvest
    def create(entity)
      url = "#{DEFAULT_HOST}/#{entity.path}"
      uri = URI(url)
      response = http_response(:post, uri, body: entity.to_hash)
      entity.attributes = JSON.parse(response.body)
      entity
    end

    # Updates an `entity` in your Harvest account.
    #
    # @param entity [Harvesting::Models::Base] An existing record in your Harvest account
    # @return [Harvesting::Models::Base] A subclass of `Harvesting::Models::Base` updated with the response from Harvest
    def update(entity)
      url = "#{DEFAULT_HOST}/#{entity.path}"
      uri = URI(url)
      response = http_response(:patch, uri, body: entity.to_hash)
      entity.attributes = JSON.parse(response.body)
      entity
    end

    # It removes an `entity` from your Harvest account.
    #
    # @param entity [Harvesting::Models::Base] A record to be removed from your Harvest account
    # @return [Hash]
    # @raise [UnprocessableRequest] When HTTP response is not 200 OK
    def delete(entity)
      url = "#{DEFAULT_HOST}/#{entity.path}"
      uri = URI(url)
      response = http_response(:delete, uri)
      raise UnprocessableRequest(response.to_s) unless response.code.to_i == 200
      JSON.parse(response.body)
    end

    # Performs a GET request and returned the parsed JSON as a Hash.
    #
    # @param path [String] path to be combined with `DEFAULT_HOST`
    # @param opts [Hash] key/values will get passed as HTTP (GET) parameters
    # @return [Hash]
    def get(path, opts = {})
      url = "#{DEFAULT_HOST}/#{path}"
      url += "?#{opts.map {|k, v| "#{k}=#{v}"}.join("&")}" if opts.any?
      uri = URI(url)
      response = http_response(:get, uri)
      JSON.parse(response.body)
    end

    private

    def http_response(method, uri, opts = {})
      response = nil

      http = HTTP["User-Agent" => "Harvesting Ruby Gem",
                  "Authorization" => "Bearer #{@access_token}",
                  "Harvest-Account-ID" => @account_id]
      params = {}
      if opts[:body]
        params[:json] = opts[:body]
      end
      response = http.send(method, uri, params)

      raise Harvesting::AuthenticationError.new(response.to_s) if auth_error?(response)
      raise Harvesting::UnprocessableRequest.new(response.to_s) if response.code.to_i == 422

      response
    end

    def auth_error?(response)
      response.code.to_i == 403 || response.code.to_i == 401
    end
  end
end
