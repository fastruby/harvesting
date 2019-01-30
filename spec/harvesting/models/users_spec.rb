require 'spec_helper'

RSpec.describe Harvesting::Models::Users, :vcr do
  let(:attrs) { Hash.new }
  let(:users) { Harvesting::Models::Users.new(attrs, {}, client: harvest_client) }

  include_context "harvest data setup"

  let(:page1_results) do
    entries = []
    100.times { entries.push({}) }
    {
        "users" => entries,
        "per_page" => 100,
        "total_pages" => 2,
        "total_entries" => 115,
        "next_page" => 2,
        "previous_page" => nil,
        "page" => 1
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

  let(:attrs) { page1_results }

  describe "#fetch_next_page" do
    it "provides next page content" do
      stub_request(:get, /users/).
            with(query: {"page" => "2"}).
            to_return( { body: page2_results.to_json } )

      users.send(:fetch_next_page)
      count = 0
      users.entries.each { |entry| count += 1 }
      expect(count).to eq 115

      expect(WebMock).to have_requested(:get, /users/).
          with(query: {"page" => "2"})
    end
  end

end