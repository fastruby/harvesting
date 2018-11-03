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

        expect(clients.map(&:name)).to eq(["Toto", "Pepe"])
      end
    end
  end

  describe "#me", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    it "returns the authenticated user" do
      user = subject.me
      expect(user.first_name).to eq(account_first_name)
      expect(user.last_name).to eq(account_last_name)
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

      it 'time entries provide access to associated user' do
        first_time_entry = time_entries.first
        expect(first_time_entry.user.id).to be
        expect(first_time_entry.user.name).to be
      end

      it 'time entires provide access to associated task' do
        first_time_entry = time_entries.first
        expect(first_time_entry.task.id).to be
        expect(first_time_entry.task.name).to eq('Coding')
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
    end
  end
end
