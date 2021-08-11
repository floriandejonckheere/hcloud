# HCloud

![Continuous Integration](https://github.com/floriandejonckheere/hcloud/workflows/Continuous%20Integration/badge.svg)
![Release](https://img.shields.io/github/v/release/floriandejonckheere/hcloud?label=Latest%20release)

Native Ruby integration with the Hetzner Cloud API.

## Installation

Since there is already a gem on RubyGems with the name `hcloud`, this gem is not published.
To use it, add this line to your application's Gemfile:

```ruby
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "hcloud", github: "floriandejonckheere/hcloud"
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hcloud

## Usage

```ruby
require "hcloud"

# Create a new client
client = HCloud::Client.new(access_token: "my_access_token")

# Set client as default connection
HCloud::Client.connection = client

# Create resource
ssh_key = HCloud::SSHKey.new(name: "My SSH key", public_key: "ssh-rsa ...")
ssh_key.create

# Find resource by ID
ssh_key = HCloud::SSHKey.find(1)

# Update resource
ssh_key.updatable_attributes # => [:name, :labels]
ssh_key.name = "New name"
ssh_key.update

# Delete resource
ssh_key.delete
ssh_key.deleted?
# => true

# For detailed usage of resources, refer to the class documentation

# When specifying associated resources, you can either use an instance of the resource, an integer as ID or a string as name.
# The following calls are equivalent:
server = HCloud::Server.new(name: "my_server", location: "fsn", ...)
server = HCloud::Server.new(name: "my_server", location: 1, ...)
server = HCloud::Server.new(name: "my_server", location: Location.new(name: "fsn"), ...)
```

The gem does little validation on your input or behaviour, and expects you to use it in a sane way.

## Features

Not all Hetzner Cloud API endpoints have been implemented yet.

| Resource              | State           |
|-----------------------|-----------------|
| Actions               | Implemented     |
| Certificates          | Not implemented |
| Certificate Actions   | Not implemented |
| Datacenters           | Implemented     |
| Firewalls             | Not implemented |
| Firewall Actions      | Not implemented |
| Floating IPs          | Implemented     |
| Floating IP Actions   | Implemented     |
| Images                | Implemented     |
| Image Actions         | Implemented     |
| ISOs                  | Implemented     |
| Load Balancers        | Not implemented |
| Load Balancer Actions | Not implemented |
| Load Balancer Types   | Not implemented |
| Locations             | Implemented     |
| Networks              | Not implemented |
| Network Actions       | Not implemented |
| Pricing               | Not implemented |
| Servers               | Not implemented |
| Server Actions        | Not implemented |
| Server Types          | Implemented     |
| SSH Keys              | Implemented     |
| Volumes               | Implemented     |
| Volume Actions        | Implemented     |

## Testing

```ssh
# Run test suite (without integration tests)
bundle exec rspec

# Run integration tests (WARNING: THIS WILL DESTROY **ALL** RESOURCES AFTER EACH RUN)
bundle exec rspec --tag integration
```

## Releasing

To release a new version, update the version number in `lib/hcloud/version.rb`, update the changelog, commit the files and create a git tag starting with `v`, and push it to the repository.
Github Actions will automatically run the test suite, build the `.gem` file and push it to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/floriandejonckheere/hcloud](https://github.com/floriandejonckheere/hcloud). 

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
