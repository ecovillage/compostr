# Compostr

Compostr is extracted code from the `wp_event` gem, a solution to feed a specific wordpress instance with specific Custom Post Type instances.

Compostr is a somewhat weirdly engineered wrapper to decorate ruby classes such that they can be pushed to (or fetched from) a wordpress installation that defines corresponing CPTs (Custom Post Types).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'compostr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install compostr

## Usage

### In a nutshell

Define a CPT class like this: (TODO: show examples from test case)

### Logger

Use Compostr::logger if you want to feed Compostrs logs into your main applications log or redirect them somewhere.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/compostr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

That said, just drop me a line.
