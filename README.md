# Compostr is heavily WIP!

# Compostr

Compostr is extracted code from the [`wp_event` gem](https://github.com/ecovillage/wp_event), a solution to feed a specific wordpress instance with specific Custom Post Type instances.

Its still a heavy WIP, although used in hacky production.

Compostr is a somewhat weirdly engineered wrapper to decorate ruby classes such that they can be pushed to (or fetched from) a wordpress installation that defines corresponing CPTs (Custom Post Types).

It would be fun to discuss on `Compostr`s development history and design decisions, but unfortunately that is out of scope for the time being.

Licensed under the GPLv3+, Copyright 2016, 2017, 2018 Felix Wolfsteller.

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

Define a CPT class like this (you still need Wordpress PHP code!):

```ruby
require 'compostr'

class ProgrammingLanguage < Compostr::CustomPostType
  wp_post_type 'programming_language' # `post_type` as known by WP
  wp_custom_field_single 'awesomeness' # 'meta' field in WP, just one value is queried and set
  wp_custom_field_multi 'further_links' # 'meta' field(s) in WP, can have multiple values
end
```

Now `ProgrammingLanguage`s can be queried and posted to your Wordpress installation.  Instances of this class will automatically respond to `content`, `id`, `title` and `featured_image_id` (corresponding to the Wordpress `post_content`, `id`, `post_title` and `featured_image_id`).

```ruby
require 'compostr'

fooby = ProgrammingLanguage.new title:         'Fooby',
                                content:       'Easy to learn language',
                                awesomeness:   '3',
                                further_links: ['foo://by', 'foo://byebye']
# Reading this I agree the API is awkward
Compostr::Syncer.new(nil).merge_push fooby, nil
```

Compostr comes prepared with `UUID` information of CPT instances, to e.g. distinctively identify entities across different WP instances where entities might have different `post_id`s.

There are some tests implemented, which illustrate further usage.

### Configuration

Global configuration is given in `compostr.conf`, where connection information to the Wordpress installation is defined:

    # compostr.conf
    host:     "wordpress.mydomain"
    username: "admin"
    password: "buzzword"
    language_term: "Deutsch"
    author_id: 1
    use_ssl: true

### Logging/Logger

Although logging should not be a main Compostr concern, it was helpful to include some handy helpers.

Use `Compostr::logger` if you want to feed Compostrs logs into your main applications log or redirect them somewhere.

To mixin `info`, `warn` and other logging functions into your class/module do an `include Compostr::Logging`.

To make Compostr-logs use your logger, set it like this: `Compostr::logger = mylogger`.

### EntityCache

Until you provide some Wordpress PHP code to query custom post types via their Custom ("meta") Fields, to query and work with CPTs, all data will be read into memory using `Compostr::EntityCache`.

### Syncer

The `Syncer` class deals with wordpress data updates.

To avoid re-creation of Posts and the respecive Meta Fields on update actions, prior cache population is needed and employed.

### Image Upload/Featured images

Images can be uploaded to Wordpress using the `ImageUploader` class, which comes with a Cache to avoid duplicate upload of images (where "duplication" reduces to "same name"!).

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ecovillage/compostr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://contributor-covenant.org) code of conduct.

That said, just drop me a line.
