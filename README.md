# PathBuilder

A friendly syntax for writing url-like paths in Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'path-builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install path-builder

## Usage

Require the gem:

```ruby
require 'path-builder'
```

Make a path:
```ruby
path = PathBuilder.new
path.api.moo.to_s #=> 'api/moo/'
```

Add a variable path segment:
```ruby
path = PathBuilder.new
path.api.(:version).moo.to_s('v1') #=> 'api/v1/moo/'
```

Or use `#[]` instead of `#to_s`:
```ruby
path = PathBuilder.new
path.api.(:version).moo['v1'] #=> 'api/v1/moo/'
```

Why is that dot there? Because Ruby. Can we remove the dot? Yes, because Ruby:
```ruby
path = PathBuilder.new
path.api(:version).moo['v1'] #=> 'api/v1/moo/'
```

Use it out of the box:
```ruby
PathBuilder.new.api(:version).moo['v1'] #=> 'api/v1/moo/'
```

Put in a url:
```ruby
path = PathBuilder.new
path[] = 'http://example.com'
path.api(:version).moo.to_s #=> 'http://example.com/api/v1/moo'
```

Reuse it:
```ruby
ApiPath = PathBuilder.new.path.api(:version).save!
ApiPath.new.moo['v1'] #=> 'api/v1/moo'
```

Reuse even more:
```ruby
ApiPath = ApiPath['v1']
ApiPath.new.moo.to_s #=> 'api/v1/moo'
```

`break_on_empty` may help you REST...
```ruby
UsersPath = ApiPath.users(:user_id).save!

UsersPath.new.to_s #=> 'api/v1/users/user_id/'
UsersPath.new.to_s(break_on_empty: true) #=> 'api/v1/users/'
UsersPath.new.to_s(1, break_on_empty: true) #=> 'api/v1/users/1'

# Or just:

UsersPath.break_on_empty = true # PROTIP: You can set PathBuilder#break_on_empty in a config file.

UsersPath.new[] #=> 'api/v1/users/'
UsersPath.new[nil] #=> 'api/v1/users/'
UsersPath.new['1'] #=> 'api/v1/users/1'
UsersPath.new.comments[] #=> 'api/v1/users'
UsersPath.new.comments['1'] #=> 'api/v1/users/1/comments/'
UsersPath.new.comments(:comment_id).post['1'] #=> 'api/v1/users/1/comments/'
UsersPath.new.comments(:comment_id).post['1', '2'] #=> 'api/v1/users/1/comments/2/post'
```

Curious on how it works? Read the 88 line [source].

Have fun.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/path-builder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[source]: blob/master/lib/path-builder.rb
