# Harvesting

A Ruby gem to interact with the Harvest API v2.0 and forward.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'harvesting'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install harvesting

## Usage

In order to start using this gem you will need your personal token and an
account id:

### Identity

You can find these details over here: https://id.getharvest.com/developers

If you don't specify values for `access_token` or `account_id`, it will default
to these environment variables:

* `ENV['HARVEST_ACCESS_TOKEN']`
* `ENV['HARVEST_ACCOUNT_ID']`

That means that you could build a client like this:

    # $ export HARVEST_ACCESS_TOKEN=abc
    # $ export HARVEST_ACCOUNT_ID=12345678
    client = Harvesting::Client.new
    client.me
    > => #<Harvesting::Models::User:0x007ff8830658f0 @attributes={"id"=>2108614, "first_name"=>"Ernesto", "last_name"=>"Tagwerker", ... >

If you don't specify a valid combination of token and account id, your code will
raise this error:

    client = Harvesting::Client.new(access_token: "foo", account_id: "bar")
    client.me
    > Harvesting::AuthenticationError: {"error":"invalid_token","error_description":"The access token provided is expired, revoked, malformed or invalid for other reasons."}

If your personal token and account id are valid, you should see something like
this:

    client = Harvesting::Client.new(access_token: "<your token here>", account_id: "<your account id here>")
    user = client.me
    > => #<Harvesting::Models::User:0x007ff8830658f0 @attributes={"id"=>2108614, "first_name"=>"Ernesto", "last_name"=>"Tagwerker", ... >

    user.id
    > => 2108614

### Clients

    client.clients
    > => [#<Harvesting::Models::Client:0x007ff718d65fd0 @attributes={"id"=>6760580, "name"=>"Toto", "is_active"=>true, "address"=>"" ... >

    client = client.clients.first
    > => #<Harvesting::Models::Client:0x007ff718cf5fc8 @attributes={"id"=>6760580, "name"=>"Toto",
    ... >

### Time Entries

    time_entries = client.time_entries
    > => #<Harvesting::Models::TimeEntries:0x007ff71913e3a0 @attributes={"per_page"=>100, "total_pages"=>1, "total_entries"=>14, "next_page"=>nil, "previous_page"=>nil, "page"=>1, "links"=>{"first"=>"https://api.harvestapp.com/v2/time_entries?limit=1&page=1&per_page=100", "next"=>nil, "previous"=>nil, "last"=>"https://api.harvestapp.com/v2/time_entries?limit=1&page=1&per_page=100"}}, ... >

    entry = time_entries.first
    > => #<Harvesting::Models::TimeEntry:0x007ff71913dfe0 @attributes={"id"=>792860513, "spent_date"=>"2018-05-14", "hours"=>1.0, "notes"=>"hacked the things", "is_locked"=>false, "locked_reason"=>nil, "is_closed"=>false, "is_billed"=>false, "timer_started_at"=>nil, "started_time"=>nil, "ended_time"=>nil, "is_running"=>false, "billable"=>true, "budgeted"=>false, "billable_rate"=>nil, "cost_rate ... >

### Tasks

    tasks = client.tasks
    > => #<Harvesting::Models::Tasks:0x007ff718897990 @attributes={"per_page"=>100, "total_pages"=>1, "total_entries"=>6, "next_page"=>nil, "previous_page"=>nil, "page"=>1, "links"=>{"first"=>"https://api.harvestapp.com/v2/tasks?page=1&per_page=100", "next"=>nil, ... >

### Projects

    projects = client.projects
    > => #<Harvesting::Models::Projects:0x007ff718e1c8e8 @attributes={"per_page"=>100, "total_pages"=>1, "total_entries"=>1, "next_page"=>nil, "previous_page"=>nil, "page"=>1, "links"=>{"first"=>"https://api.harvestapp.com/v2/projects?page=1&per_page=100", ... >

    project = projects.first
    > => #<Harvesting::Models::Project:0x007ff718e1c618 @attributes={"id"=>17367712, "name"=>"Foo", "code"=>"", "is_active"=>true, "is_billable"=>true, "is_fixed_fee"=>false, "bill_by"=>"none", "budget"=>nil, "budget_by"=>"none", "budget_is_monthly"=>false, "notify_when_over_budget"=>false, "over_budget_notification_percentage"=>80.0, "show_budget_to_all"=>false, "created_at"=>"2018-05-13T03:30:06Z", ... >

## Roadmap

There are many things to be developed for this gem. For now they are tracked here: [TODO.md](https://github.com/ombulabs/harvesting/blob/master/TODO.md)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ombulabs/harvesting. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Harvesting project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ombulabs/harvesting/blob/master/CODE_OF_CONDUCT.md).
