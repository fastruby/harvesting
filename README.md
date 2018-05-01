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

    client = Harvesting::Client.new(access_token: "<your token here>", account_id: "<your account id here>")
    client.me
    > => #<Harvesting::Models::User:0x007ff8830658f0 @attributes={"id"=>2108614, "first_name"=>"Ernesto", "last_name"=>"Tagwerker", ... >

If you don't specify a valid combination of token and account id, you will
get this error:

    client = Harvesting::Client.new(access_token: "foo", account_id: "bar")
    client.me
    > Harvesting::AuthenticationError: {"error":"invalid_token","error_description":"The access token provided is expired, revoked, malformed or invalid for other reasons."}

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ombulabs/harvesting. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Harvesting project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/ombulabs/harvesting/blob/master/CODE_OF_CONDUCT.md).
