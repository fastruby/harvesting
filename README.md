# Harvesting

[![Build Status](https://travis-ci.org/fastruby/harvesting.svg?branch=main)](https://travis-ci.org/fastruby/harvesting)
[![Code Climate](https://codeclimate.com/github/fastruby/harvesting/badges/gpa.svg)](https://codeclimate.com/github/fastruby/harvesting)
[![codecov](https://codecov.io/gh/fastruby/harvesting/branch/main/graph/badge.svg)](https://codecov.io/gh/fastruby/harvesting)

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

## Documentation

The API is documented [here](https://www.rubydoc.info/github/fastruby/harvesting)

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

```ruby
# $ export HARVEST_ACCESS_TOKEN=abc
# $ export HARVEST_ACCOUNT_ID=12345678
client = Harvesting::Client.new
client.me
# => #<Harvesting::Models::User:0x007ff8830658f0 @attributes={"id"=>2108614, "first_name"=>"Ernesto", "last_name"=>"Tagwerker", ... >
```

If you don't specify a valid combination of token and account id, your code will
raise this error:

```ruby
client = Harvesting::Client.new(access_token: "foo", account_id: "bar")
client.me
# Harvesting::AuthenticationError: {"error":"invalid_token","error_description":"The access token provided is expired, revoked, malformed or invalid for other reasons."}
```

If your personal token and account id are valid, you should see something like
this:

```ruby
client = Harvesting::Client.new(access_token: "<your token here>", account_id: "<your account id here>")
user = client.me
# => #<Harvesting::Models::User:0x007ff8830658f0 @attributes={"id"=>2108614, "first_name"=>"Ernesto", "last_name"=>"Tagwerker", ... >

user.id
# => 2108614
```

### Clients

```ruby
client.clients
# => #<Harvesting::Models::Clients:0x007ff718d65fd0>

client = client.clients.first
# => #<Harvesting::Models::Client:0x007ff718cf5fc8 @attributes={"id"=>6760580, "name"=>"Toto",
# ... >
```

### Time Entries

```ruby
time_entries = client.time_entries
# => #<Harvesting::Models::TimeEntries:0x007ff71913e3a0 @attributes={"per_page"=>100, "total_pages"=>1, "total_entries"=>14, "next_page"=>nil, "previous_page"=>nil, "page"=>1, "links"=>{"first"=>"https://api.harvestapp.com/v2/time_entries?limit=1&page=1&per_page=100", "next"=>nil, "previous"=>nil, "last"=>"https://api.harvestapp.com/v2/time_entries?limit=1&page=1&per_page=100"}}, ... >

entry = time_entries.first
# => #<Harvesting::Models::TimeEntry:0x007ff71913dfe0 @attributes={"id"=>792860513, "spent_date"=>"2018-05-14", "hours"=>1.0, "notes"=>"hacked the things", "is_locked"=>false, "locked_reason"=>nil, "is_closed"=>false, "is_billed"=>false, "timer_started_at"=>nil, "started_time"=>nil, "ended_time"=>nil, "is_running"=>false, "billable"=>true, "budgeted"=>false, "billable_rate"=>nil, "cost_rate ... >
```

### Tasks

```ruby
tasks = client.tasks
# => #<Harvesting::Models::Tasks:0x007ff718897990 @attributes={"per_page"=>100, "total_pages"=>1, "total_entries"=>6, "next_page"=>nil, "previous_page"=>nil, "page"=>1, "links"=>{"first"=>"https://api.harvestapp.com/v2/tasks?page=1&per_page=100", "next"=>nil, ... >
```

### Projects

```ruby
projects = client.projects
# => #<Harvesting::Models::Projects:0x007ff718e1c8e8 @attributes={"per_page"=>100, "total_pages"=>1, "total_entries"=>1, "next_page"=>nil, "previous_page"=>nil, "page"=>1, "links"=>{"first"=>"https://api.harvestapp.com/v2/projects?page=1&per_page=100", ... >

project = projects.first
# => #<Harvesting::Models::Project:0x007ff718e1c618 @attributes={"id"=>17367712, "name"=>"Foo", "code"=>"", "is_active"=>true, "is_billable"=>true, "is_fixed_fee"=>false, "bill_by"=>"none", "budget"=>nil, "budget_by"=>"none", "budget_is_monthly"=>false, "notify_when_over_budget"=>false, "over_budget_notification_percentage"=>80.0, "show_budget_to_all"=>false, "created_at"=>"2018-05-13T03:30:06Z", ... >
```

### Invoices
```ruby
invoices = client.invoices
# => #<Harvesting::Models::Invoices:0x00007fc8905671f0 @models={}, @attributes={"per_page"=>100, "total_pages"=>1, "total_entries"=>3, "next_page"=>nil, "previous_page"=>nil, "page"=>1, "links"=>{"first"=>"https://api.harvestapp.com/v2/invoices?page=1&per_page=100", ... >

invoice = invoices.first
# => #<Harvesting::Models::Invoice:0x00007f8c37eb6d18 @models={}, @attributes={"id"=>23831208, "client_key"=>"73688e97a43ed497ace45939eb76db6b18427b80", "number"=>"3", "purchase_order"=>"", "amount"=>750.0, "due_amount"=>750.0, "tax"=>nil, "tax_amount"=>0.0, "tax2"=>nil, "tax2_amount"=>0.0, "discount"=>nil, "discount_amount"=>0.0, "subject"=>"", "notes"=>"", "state"=>"draft", "period_start"=>nil, ... >
```

An invoice can have many line items:
```ruby
line_items = invoice.line_items
# => [#<Harvesting::Models::LineItem:0x00007f92617ce8e0 @models={}, @attributes={"id"=>109677268, "kind"=>"Service", "description"=>"", "quantity"=>3.0, "unit_price"=>250.0, "amount"=>750.0, "taxed"=>false, "taxed2"=>false, "project"=>{"id"=>24566828, "name"=>"Harvest Billing Automation", "code"=>""}}, ... >]
```

You can filter invoices by various attributes. E.g. `client.invoices(state: "draft")` only returns invoices in a draft state.

### Nested Attributes

The Harvest v2 API embeds some data in JSON objects. You can access nested attributes quite naturally.
For example, to access the user id for a time entry instance, `entry`, use:

```ruby
entry.user.id
```

Or to access the name of the client on a project instance, `project`:
```ruby
project.client.name
```

## Tips

### Deleting All Items

When you need to delete all items, care needs to be taken, because the API uses pagination. The following code will only delete data from _every other_ page.

```ruby
# WARNING - only deletes every other page
client.time_entries.each do |time_entry|
  time_entry.delete
end
```

While iterating over items from the first page, all of those items will be deleted. This will result in moving items from the second page onto the first page. If there are only two pages, then the second page will be empty. If there are more than two pages, then the second page will now contain items which would have previously appeared on the third page. Deleting those items will move the items from the fourth page on to the third page, and so on.

Instead you need to make sure you get access to all of the time entry objects before you try to delete any of them. The easiest way to do this is to convert the `Enumerable` instance into an `Array`, by calling `#to_a`, before you iterate over it.

```ruby
# GOOD - This should do what you want
client.time_entries.to_a.each do |time_entry|
  time_entry.delete
end
```

## Roadmap

There are many things to be developed for this gem. For now they are tracked here: [TODO.md](https://github.com/fastruby/harvesting/blob/main/TODO.md)

## Releases

You can find more info [here](RELEASE_NOTES.md)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

    ./bin/setup
    rake

To install this gem onto your local machine, run `bundle exec rake install`.

### Using Docker

This setup allows you to create a completely isolated development environment for working on this gem. The version of ruby used for development and the gems that it depends on will remain inside the container.

After checking out the repo, run `docker-compose build` to create the `gem` container. Running `docker-compose run gem bash` will get you a bash session inside the container. From there, you can follow the instructions in the "Without Docker" section above.

### Running Tests

The tests in this project use the [VCR gem](https://github.com/vcr/vcr) to record and playback all interactions with the Harvest API. This allows you to run the test suite without having an account at Harvest for testing.

If you add a test that requires making an additional API call, then you'll need to make adjustments to the `.env` file to provide account details that are required by the test suite.

*WARNING*: The test suite is destructive. It deletes all entities from the account before it runs. _DO NOT_ run it against a Harvest account which contains information that you need to preserve. Instead, create a Harvest account for testing.

If you need to refresh the VCR cassettes, the easiest way is to delete all of the files located under [`fixtures/vcr_cassettes`](fixtures/vcr_cassettes). The next time the test suite is run, VCR will make actual calls against the Harvest API and record the responses into updated cassette files.

Effort has been taken to ensure that private information is excluded from the recorded cassettes. To adjust this further, add additional `filter_sensitive_data` calls to [`spec/spec_helper.rb`](spec/spec_helper.rb).

### Models

The models in this project reflect the Harvest v2 API endpoints:

 * client
 * contact
 * task
 * task_assignment
 * project
 * user
 * time_entry

There are also models for the Harvest v2 API collection endpoints:

 * clients
 * contacts
 * tasks
 * task_assignments
 * projects
 * users
 * time_entries

These collection models handle the Harvest v2 API pagination automatically, making it easy to enumerate through all the instances of each type.

The models try to reduce code duplication through base class helper functions to automatically define accessors for the attributes included in each type returned by the Harvest v2 API.
The `Harvesting::Base::attributed` method will define accessors for each simple attribute included in an array passed as an argument. Data is returned from these accessors as strings.

Some data is returned from Harvest as nested JSON (e.g. time_entry.project.name). A base class helper to expose this using the available models
is also present. The `Harvesting::Base::modeled` method will define accessors for each object attribute included in options. Both the name of the attribute and the model to use in accessing that data is supplied.
Data is returned from these accessors as model objects.

NOTE: Nesting model objects requires that the nested model types be defined before the nesting model type. E.g. if `project` contains a nested `client`, then `client` must be defined *before* `project` in the `harvesting.rb` include list.

## Releases

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

We follow semantic versioning for version numbers: [https://semver.org](https://semver.org)

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/fastruby/harvesting](https://github.com/fastruby/harvesting). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Harvesting project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/fastruby/harvesting/blob/main/CODE_OF_CONDUCT.md).
