# HCloud

![Continuous Integration](https://github.com/floriandejonckheere/hcloud/workflows/Continuous%20Integration/badge.svg)
![Release](https://img.shields.io/github/v/release/floriandejonckheere/hcloud?label=Latest%20release)

Unofficial Ruby integration with the [Hetzner Cloud API](https://docs.hetzner.cloud/).

## Installation

Add this line to your application's Gemfile:

```ruby
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "hetznercloud"
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

# Alternate syntax:
ssh_key = HCloud::SSHKey.create(name: "My SSH key", public_key: "ssh-rsa ...")

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

The gem aims to provide a simple, object-oriented interface to the Hetzner Cloud API.
It does not aim to be an authoritative source of information, and as such does little validation on your input data or behaviour.
It expects you to use it in a sane way.

## Features

Not all Hetzner Cloud API endpoints have been implemented yet.

| Resource              | State                 |
|-----------------------|-----------------------|
| Actions               | Implemented           |
| Certificates          | Implemented           |
| Certificate Actions   | Implemented           |
| Datacenters           | Implemented           |
| Firewalls             | Implemented           |
| Firewall Actions      | Implemented           |
| Floating IPs          | Implemented           |
| Floating IP Actions   | Implemented           |
| Images                | Implemented           |
| Image Actions         | Implemented           |
| ISOs                  | Implemented           |
| Load Balancers        | Implemented           |
| Load Balancer Actions | Not implemented       |
| Load Balancer Types   | Implemented           |
| Locations             | Implemented           |
| Primary IPs           | Not implemented       |   
| Primary IP Actions    | Not implemented       |   
| Networks              | Implemented           |
| Network Actions       | Implemented           |
| Placement Groups      | Implemented           |
| Pricing               | Implemented           |
| Servers               | Partially implemented |
| Server Actions        | Not implemented       |
| Server Types          | Implemented           |
| SSH Keys              | Implemented           |
| Volumes               | Implemented           |
| Volume Actions        | Implemented           |

## Testing

```ssh
# Run test suite (without integration tests)
bundle exec rspec

# Run integration tests (WARNING: THIS WILL DESTROY **ALL** RESOURCES AFTER EACH RUN)
bundle exec rspec --tag integration
```

## Debugging

### Logging

When using the gem in your code, you can pass a `logger:` argument to `HCloud::Client`:

```ruby
logger = Logger.new("log/http.log")
logger.level = :debug

client = HCloud::Client.new(access_token: "my_access_token", logger: logger)
```

When executing the test suite, set `LOG_LEVEL` environment variable to `debug` in order to see HTTP requests.

### Endpoint

`HCloud::Client` also accepts an alternate endpoint:


```ruby
client = HCloud::Client.new(access_token: "my_access_token", endpoint: "https://myproxy/v1")
```

## Releasing

To release a new version, update the version number in `lib/hcloud/version.rb`, update the changelog, commit the files and create a git tag starting with `v`, and push it to the repository.
Github Actions will automatically run the test suite, build the `.gem` file and push it to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/floriandejonckheere/hcloud](https://github.com/floriandejonckheere/hcloud). 

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
