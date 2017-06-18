# RSpec::Cheki
[![Gem Version](https://badge.fury.io/rb/rspec-cheki.svg)](https://badge.fury.io/rb/rspec-cheki)
[![Build Status](https://travis-ci.org/izumin5210/rspec-cheki.svg?branch=master)](https://travis-ci.org/izumin5210/rspec-cheki)
[![license](https://img.shields.io/github/license/izumin5210/rspec-cheki.svg)](https://github.com/izumin5210/rspec-cheki/blob/master/LICENSE.txt)
[![Dependency Status](https://gemnasium.com/badges/github.com/izumin5210/rspec-cheki.svg)](https://gemnasium.com/github.com/izumin5210/rspec-cheki)
[![Inline docs](http://inch-ci.org/github/izumin5210/rspec-cheki.svg?branch=master&style=shields)](http://inch-ci.org/github/izumin5210/rspec-cheki)

Support snapshot testing, inspired [Jest](https://facebook.github.io/jest/).

```ruby
expect(response.body).to match_snapshot

# or...

expect(response.body).to say_cheese
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rspec-cheki'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-cheki

## Usage

Requrie `rspec-cheki` from your `spec_helper.rb`.

```ruby
requrie 'rspec-cheki'
```

### `match_snapshot` matcher

```ruby
expect(response.body).to match_snapshot

# And you can use `say_cheese` matcher (This is an alias of `match_snapshot` matcher)
expect(response.body).to say_cheese
```

### Update snapshots

Run rspec with `UPDATE_SNAPSHOTS=1` to update snapshtos files.

```
$ UPDATE_SNAPSHOTS=1 rspec
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/rspec-cheki. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

