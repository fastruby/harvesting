require 'spec_helper'

RSpec.describe Harvesting::Client do
  let(:access_token) do
    "9999999.pt.abcdef"
  end
  let(:account_id) { "848484" }

  describe "#initialize" do
    context "when parameters are valid" do
      it "builds a client with a token and account" do
        Harvesting::Client.new(access_token: "foo", account_id: "bar")
      end
    end

    context "when parameters are invalid and ENV is not defined" do
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
      let(:account_id) { 919191 }

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
      let(:account_id) { 919191 }

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
      expect(user.first_name).to eq("Ernesto")
      expect(user.last_name).to eq("Tagwerker")
    end
  end

  describe "#time_entries", :vcr do
    subject { Harvesting::Client.new(access_token: access_token, account_id: account_id) }

    context "when account has no entries" do
      let(:account_id) { 919191 }

      it "returns the time_entries associated with the account" do
        time_entries = subject.time_entries
        expect(time_entries.map(&:id)).to be_empty
      end
    end

    context "when account has entries" do
      it "returns the time_entries associated with the account" do
        time_entries = subject.time_entries
        expect(time_entries.size).to eq(119)
      end
    end

    context "when iterating over the next page" do
      it "lets me" do
        cursor = 0
        time_entries = subject.time_entries
        time_entries.each_with_index do |entry, index|
          cursor = index
          expect(entry.id).to be
        end

        expect(cursor).to eq(118)
      end
    end
  end
end
