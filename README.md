# Retrodb

[Retrosheet](https://www.retrosheet.org) provides event-grained data files for all MLB games dating back to 1870. However, these files are difficult to work with without using an esoteric Windows-based software package. 

There are no widely-available tools to help build a relational database from Retrosheet event files. Such a database is very useful for statistical analysis of baseball games. 

Retrodb aims to make acquiring, parsing, and storing Retrosheet data easier than it currently is. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'retrodb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install retrodb

## Usage

...

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jknabl/retrodb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
