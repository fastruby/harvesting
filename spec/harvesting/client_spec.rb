require 'spec_helper'

RSpec.describe Harvesting::Client, :vcr do
  include_context "harvest data setup"

  describe "#initialize" do
    context "when parameters are valid" do
      it "builds a client with a token and account" do
        Harvesting::Client.new(access_token: "foo", account_id: "bar")
      end
    end

    context "when parameters are invalid and ENV is not defined" do
      before do
        stub_const("ENV", {})
      end

      it "fails" do
        expect do
          Harvesting::Client.new
        end.to raise_error(ArgumentError, "Access token and account id are required. Access token: ''. Account ID: ''.")
      end

      context "but ENV constants are defined" do
        before do
          stub_const("ENV", {'HARVEST_ACCESS_TOKEN' => "abc", 'HARVEST_ACCOUNT_ID' => "123"})
        end

        subject { Harvesting::Client.new }

        it "defaults to the env variables" do
          expect do
            subject
          end.not_to raise_error

          expect(subject.access_token).to eq "abc"
          expect(subject.account_id).to eq "123"
        end
      end
    end
  end

  describe "authentication", :vcr do
    context "when client is not authenticated" do
      subject { Harvesting::Client.new(access_token: "foo", account_id: "bar") }

      it "raises a Harvesting::AuthenticationError" do
        expect do
          subject.me
        end.to raise_error(Harvesting::AuthenticationError)
      end
    end
  end

  describe "throttling", :vcr do
    context "when client reaches the API rate limit" do
      subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

      it "raises a Harvesting::RateLimitExceeded" do
        expect do
          subject.me
        end.to raise_error(Harvesting::RateLimitExceeded)
      end
    end
  end

  describe "#contacts", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when user is not an administrator" do
      it "returns the contacts associated with the account" do
        expect do
          subject.contacts
        end.to raise_error(Harvesting::AuthenticationError)
      end
    end

    context "when user is an administrator" do
      let(:access_token) { admin_access_token }
      let(:account_id) { admin_account_id }

      it "returns the contacts associated with the account" do
        contacts = subject.contacts

        expect(contacts.map(&:first_name)).to eq(["Cersei", "Jon"])
        expect(contacts.map(&:last_name)).to eq(["Lannister", "Snow"])
      end
    end
  end

  describe "#clients", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when user is not an administrator" do
      it "returns the clients associated with the account" do
        expect do
          subject.clients
        end.to raise_error(Harvesting::AuthenticationError)
      end
    end

    context "when user is an administrator" do
      let(:access_token) { admin_access_token }
      let(:account_id) { admin_account_id }

      it "returns the clients associated with the account" do
        clients = subject.clients

        expect(clients).to be_instance_of(Harvesting::Models::Clients)
        expect(clients.map(&:name)).to eq(["Toto", "Pepe"])
      end
    end
  end

  describe "#delete", :vcr do
    let(:message) do
      '{"message":"This client is not removable. It still has projects and/or invoices."}'
    end

    it "raises a UnprocessableRequest exception if entity is not removable" do
      client = Harvesting::Models::Client.new(name: "Mr. Robot")
      client.save

      project = Harvesting::Models::Project.new(
        "name" => "E-Corp",
        "client" => client.to_hash
      )
      project.save

      expect do
        client.delete
      end.to raise_error(Harvesting::UnprocessableRequest, message)
    end
  end

  describe "#me", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    # vcr cassette here:
    # fixtures/vcr_cassettes/Harvesting_Client_me/returns_the_authenticated_user.yml
    it "returns the authenticated user" do
      user = subject.me
      expect(user.first_name).to eq(ENV['HARVEST_FIRST_NAME'])
      expect(user.last_name).to eq(ENV['HARVEST_LAST_NAME'])
    end
  end

  describe "#time_entries", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when account has no entries" do
      it "returns the time_entries associated with the account" do
        time_entries = subject.time_entries
        expect(time_entries.map(&:id)).to be_empty
      end
    end

    context "when account has entries" do
      let(:access_token) { admin_access_token }
      let(:account_id) { admin_account_id }

      it "returns the time_entries associated with the account" do
        time_entries = subject.time_entries
        expect(time_entries.size).to eq(119)
      end

      it 'provide access to associated user' do
        first_time_entry = time_entries.first
        expect(first_time_entry.user).to respond_to(:id)
        expect(first_time_entry.user).to respond_to(:first_name)
      end

      it 'provide access to associated task' do
        first_time_entry = time_entries.first
        expect(first_time_entry.task).to respond_to(:id)
        expect(first_time_entry.task).to respond_to(:name)
      end

      it "correctly accesses all pages" do
        ids = []
        time_entries = subject.time_entries
        expect(time_entries.size).to be > 100

        time_entries.each do |entry|
          expect(entry.id).to be
          expect(ids).to_not include(entry.id)
          ids << entry.id
        end

        expect(ids.size).to eq(time_entries.size)
      end

      context 'with custom options' do
        let(:page1_results) do
          entries = []
          100.times { entries.push({}) }
          {
              time_entries: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: 2,
              previous_page: nil,
              page: 1
          }
          end

        let(:page2_results) do
          entries = []
          15.times { entries.push({}) }
          {
              time_entries: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: nil,
              previous_page: 1,
              page: 2
          }
        end

        it 'uses the custom options on subsequent page fetches' do
          stub_request(:get, /time_entries/).
            to_return({ body: page1_results.to_json }, { body: page2_results.to_json })

          time_entries = subject.time_entries(from: "2018-02-15", to: "2018-04-27")

          time_entries.each { |entry| }

          expect(WebMock).to have_requested(:get, /time_entries/).
            with(query: {"from" => "2018-02-15", "page" => "2", "to" => "2018-04-27"})
        end
      end
    end
  end

  describe "#users", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when iterating over the next page" do

      context 'with custom options' do
        let(:page1_results) do
          entries = []
          100.times { entries.push({}) }
          {
              users: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: 2,
              previous_page: nil,
              page: 1
          }
        end

        let(:page2_results) do
          entries = []
          15.times { entries.push({}) }
          {
              users: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: nil,
              previous_page: 1,
              page: 2
          }
        end

        it 'uses the custom options on subsequent page fetches' do
          stub_request(:get, /users/).
              to_return({ body: page1_results.to_json }, { body: page2_results.to_json })

          time_entries = subject.users(is_active: "true")

          time_entries.each { |entry| }

          expect(WebMock).to have_requested(:get, /users/).
              with(query: {"is_active" => "true", "page" => "2"})
        end
      end
    end

  end

  describe "#projects", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when iterating over the next page" do

      context 'with custom options' do
        let(:page1_results) do
          entries = []
          100.times { entries.push({}) }
          {
              projects: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: 2,
              previous_page: nil,
              page: 1
          }
        end

        let(:page2_results) do
          entries = []
          15.times { entries.push({}) }
          {
              projects: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: nil,
              previous_page: 1,
              page: 2
          }
        end

        it 'uses the custom options on subsequent page fetches' do
          stub_request(:get, /projects/).
              to_return({ body: page1_results.to_json }, { body: page2_results.to_json })

          time_entries = subject.projects(is_active: "true")

          time_entries.each { |entry| }

          expect(WebMock).to have_requested(:get, /projects/).
              with(query: {"is_active" => "true", "page" => "2"})
        end
      end
    end

  end

  describe "#tasks", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when iterating over the next page" do

      context 'with custom options' do
        let(:page1_results) do
          entries = []
          100.times { entries.push({}) }
          {
              tasks: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: 2,
              previous_page: nil,
              page: 1
          }
        end

        let(:page2_results) do
          entries = []
          15.times { entries.push({}) }
          {
              tasks: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: nil,
              previous_page: 1,
              page: 2
          }
        end

        it 'uses the custom options on subsequent page fetches' do
          stub_request(:get, /tasks/).
              to_return({ body: page1_results.to_json }, { body: page2_results.to_json })

          time_entries = subject.tasks(is_active: "true")

          time_entries.each { |entry| }

          expect(WebMock).to have_requested(:get, /tasks/).
              with(query: {"is_active" => "true", "page" => "2"})
        end
      end

      context 'with custom options' do
        let(:page1_results) do
          entries = []
          100.times { entries.push({}) }
          {
              time_entries: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: 2,
              previous_page: nil,
              page: 1
          }
          end

        let(:page2_results) do
          entries = []
          15.times { entries.push({}) }
          {
              time_entries: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: nil,
              previous_page: 1,
              page: 2
          }
        end

        it 'uses the custom options on subsequent page fetches' do
          stub_request(:get, /time_entries/).
            to_return({ body: page1_results.to_json }, { body: page2_results.to_json })

          time_entries = subject.time_entries(from: "2018-02-15", to: "2018-04-27")

          time_entries.each { |entry| }

          expect(WebMock).to have_requested(:get, /time_entries/).
            with(query: {"from" => "2018-02-15", "page" => "2", "to" => "2018-04-27"})
        end
      end
    end

  end

  describe "#users", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when iterating over the next page" do

      context 'with custom options' do
        let(:page1_results) do
          entries = []
          100.times { entries.push({}) }
          {
              users: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: 2,
              previous_page: nil,
              page: 1
          }
        end

        let(:page2_results) do
          entries = []
          15.times { entries.push({}) }
          {
              users: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: nil,
              previous_page: 1,
              page: 2
          }
        end

        it 'uses the custom options on subsequent page fetches' do
          stub_request(:get, /users/).
              to_return({ body: page1_results.to_json }, { body: page2_results.to_json })

          time_entries = subject.users(is_active: "true")

          time_entries.each { |entry| }

          expect(WebMock).to have_requested(:get, /users/).
              with(query: {"is_active" => "true", "page" => "2"})
        end
      end
    end

  end

  describe "#projects", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when iterating over the next page" do

      context 'with custom options' do
        let(:page1_results) do
          entries = []
          100.times { entries.push({}) }
          {
              projects: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: 2,
              previous_page: nil,
              page: 1
          }
        end

        let(:page2_results) do
          entries = []
          15.times { entries.push({}) }
          {
              projects: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: nil,
              previous_page: 1,
              page: 2
          }
        end

        it 'uses the custom options on subsequent page fetches' do
          stub_request(:get, /projects/).
              to_return({ body: page1_results.to_json }, { body: page2_results.to_json })

          time_entries = subject.projects(is_active: "true")

          time_entries.each { |entry| }

          expect(WebMock).to have_requested(:get, /projects/).
              with(query: {"is_active" => "true", "page" => "2"})
        end
      end
    end

  end

  describe "#tasks", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when iterating over the next page" do

      context 'with custom options' do
        let(:page1_results) do
          entries = []
          100.times { entries.push({}) }
          {
              tasks: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: 2,
              previous_page: nil,
              page: 1
          }
        end

        let(:page2_results) do
          entries = []
          15.times { entries.push({}) }
          {
              tasks: entries,
              per_page: 100,
              total_pages: 2,
              total_entries: 115,
              next_page: nil,
              previous_page: 1,
              page: 2
          }
        end

        it 'uses the custom options on subsequent page fetches' do
          stub_request(:get, /tasks/).
              to_return({ body: page1_results.to_json }, { body: page2_results.to_json })

          time_entries = subject.tasks(is_active: "true")

          time_entries.each { |entry| }

          expect(WebMock).to have_requested(:get, /tasks/).
              with(query: {"is_active" => "true", "page" => "2"})
        end
      end
    end
  end

  describe "#user_assignments", :vcr do
    context "as an admin user" do
      subject { Harvesting::Client.new(access_token: admin_access_token, account_id: account_id) }

      it 'retreives the accounts user assignments' do
        user_assignments = subject.user_assignments

        projects = user_assignments.map { |ua| ua.project.id }.uniq
        expect(projects).to contain_exactly(
          project_castle_building.id,
          project_road_building.id
        )

        users = user_assignments.map { |ua| ua.user.id }.uniq
        expect(users).to contain_exactly(
          user_john_smith.id,
          user_jane_doe.id,
          user_me.id
        )
      end
    end
  end

  describe '#task_assignments' do
    context "as an admin user" do
      subject { Harvesting::Client.new(access_token: admin_access_token, account_id: account_id) }

      it 'retrieves the accounts task assignments' do
        task_assignments = subject.task_assignments

        projects = task_assignments.map { |ta| ta.project.id }.uniq
        expect(projects).to contain_exactly(
          project_castle_building.id,
          project_road_building.id
        )

        tasks = task_assignments.map { |ta| ta.task.id }.uniq
        expect(tasks).to contain_exactly(
          task_coding.id,
          task_writing.id
        )
      end
    end
  end

  describe "#invoices", :vcr do
    subject { Harvesting::Client.new(access_token: admin_access_token, account_id: admin_account_id) }

    context "when account has no invoices" do
      it "returns the invoices associated with the account" do
        invoices = subject.invoices
        expect(invoices.map(&:id)).to be_empty
      end
    end

    context "when account has invoices" do
      it "returns the invoices associated with the account" do
        invoices = subject.invoices
        expect(invoices.size).to eq(3)
      end

      it "builds line items for invoices" do
        invoices = subject.invoices
        expect(invoices.first.line_items.first).to be_kind_of(Harvesting::Models::LineItem)
      end

      context 'with custom options' do
        it "only returns the invoices mathing the options" do
          invoices = subject.invoices(state: :draft)
          expect(invoices.size).to eq(2)
        end
      end
    end
  end
end
