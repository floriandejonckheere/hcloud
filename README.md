# HCloud

![Continuous Integration](https://github.com/floriandejonckheere/hcloud/workflows/Continuous%20Integration/badge.svg)
![Release](https://img.shields.io/github/v/release/floriandejonckheere/hcloud?label=Latest%20release)

Native Ruby integration with the Hetzner Cloud API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "hcloud"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hcloud

## Usage

```
require "hcloud"

# Create a new client
client = HCloud::Client.new(token: "my_access_token")

# Set client as default connection
HCloud::Client.connection = client

# Create resource
ssh_key = HCloud::SSHKey.new(name: "My SSH key", public_key: "ssh-rsa ...")
ssh_key.create
ssh_key.created?
# => true

# Find resource by ID
ssh_key = HCloud::SSHKey.find(3399402)

# Update resource
ssh_key.updatable_attributes # => [:name, :labels]
ssh_key.name = "New name"
ssh_key.update

# Delete resource
ssh_key.delete
ssh_key.deleted?
# => true
```

The gem does little validation on your input or behaviour, and expects you to use it in a sane way.

## Testing

```ssh
# Run test suite (without integration tests)
bundle exec rspec

# Run integration tests
bundle exec rspec --tag integration
```

## Releasing

To release a new version, update the version number in `lib/hcloud/version.rb`, update the changelog, commit the files and create a git tag starting with `v`, and push it to the repository.
Github Actions will automatically run the test suite, build the `.gem` file and push it to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/floriandejonckheere/hcloud](https://github.com/floriandejonckheere/hcloud). 

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
