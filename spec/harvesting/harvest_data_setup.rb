require 'rspec/core'

module RSpec::Core::MemoizedHelpers::ClassMethods
  # Helper method to simplify defining let methods that are wrapped in a VCR
  # cassette. Calling this method is equivalent to calling:
  # ```
  # let!(variable_name) do
  #   VCR.use_cassette('harvest_data_setup/variable_name', :record => :once, :allow_playback_repeats => true) do
  #     contents
  #   end
  # end
  # ```
  # The equivalent call would look like this:
  # ```
  # cassette_let!(variable_name) do
  #   contents
  # end
  # ```
  def cassette_let!(name, &block)
    let!(name, &block)

    # partially duplicates the implementation found at:
    # https://github.com/rspec/rspec-core/blob/58f38210492cd369784d3fe1a849c0e81342a2f2/lib/rspec/core/memoized_helpers.rb
    define_method(name) {
      __memoized.fetch_or_store(name) {
        VCR.insert_cassette("harvest_data_setup/#{name}", :record => :once, :allow_playback_repeats => true)
        result = super(&nil)
        VCR.eject_cassette
        result
      }
    }
  end
end

RSpec.shared_context "harvest data setup" do

  let(:account_first_name) { ENV["HARVEST_FIRST_NAME"] }
  let(:account_last_name) { ENV["HARVEST_LAST_NAME"] }

  let(:admin_account_id) { ENV["HARVEST_ACCOUNT_ID"] }
  let(:non_admin_account_id) { ENV["HARVEST_NON_ADMIN_ACCOUNT_ID"] }

  let(:admin_access_token) { ENV["HARVEST_ACCESS_TOKEN"] }
  let(:non_admin_access_token) { ENV["HARVEST_NON_ADMIN_ACCESS_TOKEN"] }

  let(:admin_full_name) { ENV["HARVEST_ADMIN_FULL_NAME"] }
  let(:non_admin_full_name) { ENV["HARVEST_NON_ADMIN_FULL_NAME"] }

  let(:access_token) { non_admin_access_token }
  let(:account_id) { non_admin_account_id }

  let(:one_day) { 24 * 60 * 60 }

  let!(:harvest_client) do
    VCR.use_cassette('harvest_data_setup/harvest_client', :record => :once, :allow_playback_repeats => true) do
      harvest_client = Harvesting::Client.new(
        access_token: admin_access_token,
        account_id: admin_account_id
      )
      harvest_client
    end
  end

  before do
    # VCR.use_cassette('harvest_data_setup/clear_data', :record => :once, :allow_playback_repeats => true) do
    #   harvest_client.time_entries.to_a.each do |time_entry|
    #     time_entry.delete
    #   end
    #
    #   harvest_client.tasks.to_a.each do |task|
    #     task.delete
    #   end
    #
    #   harvest_client.projects.to_a.each do |project|
    #     project.delete
    #   end
    #
    #   harvest_client.invoices.to_a.each do |invoice|
    #     invoice.delete
    #   end
    #
    #   harvest_client.clients.to_a.each do |client|
    #     client.delete
    #   end
    #
    #   harvest_client.users.to_a.each do |user|
    #     unless [admin_full_name, non_admin_full_name].include?(user.name)
    #       user.delete
    #     end
    #   end
    # end
  end

  cassette_let!(:user_john_smith) do
    john_smith = Harvesting::Models::User.new(
      {
        "first_name" => "John",
        "last_name" => "Smith",
        "email" => "john.smith@example.com"
      },
      harvest_client: harvest_client
    )
    john_smith.save
    john_smith
  end

  cassette_let!(:user_jane_doe) do
    jane_doe = Harvesting::Models::User.new(
      {
        "first_name" => "Jane",
        "last_name" => "Doe",
        "email" => "jane.doe@example.com"
      },
      harvest_client: harvest_client
    )
    jane_doe.save
    jane_doe
  end

  let!(:client_pepe) do
    VCR.use_cassette('harvest_data_setup/client_pepe', :record => :once, :allow_playback_repeats => true) do
      pepe = Harvesting::Models::Client.new(
        {
          "name" => "Pepe"
        },
        harvest_client: harvest_client
      )
      pepe.save
      pepe
    end
  end

  let!(:client_toto) do
    VCR.use_cassette('harvest_data_setup/client_toto', :record => :once, :allow_playback_repeats => true) do
      toto = Harvesting::Models::Client.new(
        {
          "name" => "Toto"
        },
        harvest_client: harvest_client
      )
      toto.save
      toto
    end
  end

  let!(:user_me) do
    VCR.use_cassette('harvest_data_setup/user_me', :record => :once, :allow_playback_repeats => true) do
      harvest_client.me
    end
  end

  let!(:contact_jon_snow) do
    VCR.use_cassette('harvest_data_setup/contact_jon_snow', :record => :once, :allow_playback_repeats => true) do
      jon_snow = Harvesting::Models::Contact.new(
        {
          "first_name" => "Jon",
          "last_name" => "Snow",
          "client" => {
              "id" => client_pepe.id.to_s
          }
        },
        harvest_client: harvest_client
      )
      jon_snow.save
      jon_snow
    end
  end

  let!(:project_road_building) do
    VCR.use_cassette('harvest_data_setup/project_road_building', :record => :once, :allow_playback_repeats => true) do
      castle_building = Harvesting::Models::Project.new(
        {
          "client" => {
              "id" => client_toto.id.to_s
          },
          "name" => "Road Building",
          "is_billable" => "true",
          "bill_by" => "Tasks",
          "budget_by" => "person"
        },
        harvest_client: harvest_client
      )
      castle_building.save
      castle_building
    end
  end

  let!(:project_castle_building) do
    VCR.use_cassette('harvest_data_setup/project_castle_building', :record => :once, :allow_playback_repeats => true) do
      castle_building = Harvesting::Models::Project.new(
        {
          "client" => {
              "id" => client_pepe.id.to_s
          },
          "name" => "Castle Building",
          "is_billable" => "true",
          "bill_by" => "Tasks",
          "budget_by" => "person"
        },
        harvest_client: harvest_client
      )
      castle_building.save
      castle_building
    end
  end

  let!(:task_coding) do
    VCR.use_cassette('harvest_data_setup/task_coding', :record => :once, :allow_playback_repeats => true) do
      coding = Harvesting::Models::Task.new(
        {
          "name" => "Coding"
        },
        harvest_client: harvest_client
      )
      coding.save
      coding
    end
  end

  cassette_let!(:task_writing) do
    writing = Harvesting::Models::Task.new(
      {
        "name" => "Writing"
      },
      harvest_client: harvest_client
    )
    writing.save
    writing
  end

  let!(:task_assigment_castle_building_coding) do
    VCR.use_cassette('harvest_data_setup/task_assigment_castle_building_coding', :record => :once, :allow_playback_repeats => true) do
      castle_building_coding = Harvesting::Models::ProjectTaskAssignment.new(
        {
            "project" => {
                "id" => project_castle_building.id.to_s
            },
            "task" => {
                "id" => task_coding.id.to_s
            }
        },
        harvest_client: harvest_client
      )
      castle_building_coding.save
      castle_building_coding
    end
  end

  cassette_let!(:task_assignment_roading_building_writing) do
    road_building_writing = Harvesting::Models::ProjectTaskAssignment.new(
      {
          "project" => {
              "id" => project_road_building.id.to_s
          },
          "task" => {
              "id" => task_writing.id.to_s
          }
      },
      harvest_client: harvest_client
    )
    road_building_writing.save
    road_building_writing
  end

  let!(:project_assignment_castle_building) do
    VCR.use_cassette('harvest_data_setup/project_assignment_castle_building', :record => :once, :allow_playback_repeats => true) do
      project_assignment = Harvesting::Models::ProjectUserAssignment.new(
        {
          "project" => {
            "id" => project_castle_building.id.to_s
          },
          "user" => {
            "id" => user_john_smith.id.to_s
          }
        },
        harvest_client: harvest_client
      )
      project_assignment.save
      project_assignment
    end
  end

  cassette_let!(:project_assignment_road_building) do
    project_assignment = Harvesting::Models::ProjectUserAssignment.new(
      {
        "project" => {
          "id" => project_road_building.id.to_s
        },
        "user" => {
          "id" => user_jane_doe.id.to_s
        }
      },
      harvest_client: harvest_client
    )
    project_assignment.save
    project_assignment
  end

  let!(:contact_cersei_lannister) do
    VCR.use_cassette('harvest_data_setup/contact_cersei_lannister', :record => :once, :allow_playback_repeats => true) do
      cersei_lannister = Harvesting::Models::Contact.new(
        {
          "first_name" => "Cersei",
          "last_name" => "Lannister",
          "client" => {
              "id" => client_toto.id.to_s
          }
        },
        harvest_client: harvest_client
      )
      cersei_lannister.save
      cersei_lannister
    end
  end

  let!(:time_entries) do
    result = []
    VCR.use_cassette('harvest_data_setup/time_entries', :record => :once, :allow_playback_repeats => true) do
      119.times do |iteration|
        time = Harvesting::Models::TimeEntry.new(
          {
            "project" => {
                "id" => project_castle_building.id.to_s
            },
            "task" => {
                "id" => task_coding.id.to_s
            },
            "spent_date" => (Time.now - one_day * (iteration + 1)).iso8601.to_s,
            "hours" => 6.to_s
          },
          harvest_client: harvest_client
        )
        time.save
        result << time
      end
    end
    result
  end
end
