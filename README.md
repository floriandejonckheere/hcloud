# HCloud

![Continuous Integration](https://github.com/floriandejonckheere/hcloud/actions/workflows/ci.yml/badge.svg)
![Release](https://img.shields.io/github/v/release/floriandejonckheere/hcloud?label=Latest%20release)

Unofficial Ruby integration with the [Hetzner Cloud API](https://docs.hetzner.cloud/).

## Installation

Add this line to your application's Gemfile:

```ruby
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

The following table lists the Hetzner Cloud API endpoints that are currently implemented.

| Resource                                                                         | State                 |
|----------------------------------------------------------------------------------|-----------------------|
| [Actions](lib/hcloud/resources/action.rb)                                        | Implemented           |
| [Certificates](lib/hcloud/resources/certificate.rb)                              | Implemented           |
| [Certificate Actions](lib/hcloud/resources/certificate.rb)                       | Implemented           |
| [Datacenters](lib/hcloud/resources/datacenter.rb)                                | Implemented           |
| [Firewalls](lib/hcloud/resources/firewall.rb)                                    | Implemented           |
| [Firewall Actions](lib/hcloud/resources/firewall.rb)                             | Implemented           |
| [Floating IPs](lib/hcloud/resources/floating_ip.rb)                              | Implemented           |
| [Floating IP Actions](lib/hcloud/resources/floating_ip.rb)                       | Implemented           |
| [Images](lib/hcloud/resources/image.rb)                                          | Implemented           |
| [Image Actions](lib/hcloud/resources/image.rb)                                   | Implemented           |
| [ISOs](lib/hcloud/resources/iso.rb)                                              | Implemented           |
| [Load Balancers](lib/hcloud/resources/load_balancer.rb)                          | Implemented           |
| [Load Balancer Actions](lib/hcloud/resources/load_balancer.rb)                   | Implemented           |
| [Load Balancer Types](lib/hcloud/resources/load_balancer.rb)                     | Implemented           |
| [Locations](lib/hcloud/resources/location.rb)                                    | Implemented           |
| [Primary IPs](lib/hcloud/resources/primary_ip.rb)                                | Implemented           |
| [Primary IP Actions](lib/hcloud/resources/primary_ip.rb)                         | Implemented           |
| [Networks](lib/hcloud/resources/network.rb)                                      | Implemented           |
| [Network Actions](lib/hcloud/resources/network.rb)                               | Implemented           |
| [Placement Groups](lib/hcloud/resources/placement_group.rb)                      | Implemented           |
| [Pricing](lib/hcloud/resources/pricing.rb)                                       | Implemented           |
| [RRSets](lib/hcloud/resources/rrset.rb)                                          | Not implemented       |
| [RRSet Actions](lib/hcloud/resources/rrset.rb)                                   | Not implemented       |
| [Servers](lib/hcloud/resources/server.rb)                                        | Partially implemented |
| [Server Actions](lib/hcloud/resources/server.rb)                                 | Not implemented       |
| [Server Types](lib/hcloud/resources/server_type.rb)                              | Implemented           |
| [SSH Keys](lib/hcloud/resources/ssh_key.rb)                                      | Implemented           |
| [Storage Boxes](lib/hcloud/resources/storage_box.rb)                             | Implemented           |
| [Storage Box Actions](lib/hcloud/resources/storage_box.rb)                       | Implemented           |
| [Storage Box Types](lib/hcloud/resources/storage_box_type.rb)                    | Implemented           |
| [Storage Box Subaccount](lib/hcloud/resources/storage_box_subaccount.rb)         | Implemented           |
| [Storage Box Subaccount Actions](lib/hcloud/resources/storage_box_subaccount.rb) | Implemented           |
| [Storage Box Snapshot](lib/hcloud/resources/storage_box_snapshot.rb)             | Implemented           |
| [Volumes](lib/hcloud/resources/volume.rb)                                        | Implemented           |
| [Volume Actions](lib/hcloud/resources/volume.rb)                                 | Implemented           |
| [Metadata](lib/hcloud/resources/metadata.rb)                                     | Implemented           |
| [Zones](lib/hcloud/resources/zone.rb)                                            | Not implemented       |
| [Zone Actions](lib/hcloud/resources/zone.rb)                                     | Not implemented       |

### Pagination

Paginated resources are wrapped in a `HCloud::Collection` that automatically fetches the next page when needed.
The collection acts as a (lazy) enumerator.
Call `to_a` to fetch all pages and parse all resources.

### Rate limiting

From the [documentation](https://docs.hetzner.cloud/#rate-limiting):

> The default limit is 3600 requests per hour and per Project.
> The number of remaining requests increases gradually.
> For example, when your limit is 3600 requests per hour, the number of remaining requests will increase by 1 every second.

The client is able to handle the rate limiting by delaying the requests if necessary and executing them whenever possible.
To enable this behaviour, pass `rate_limit: true` as argument to `HCloud::Client.new`.
Client calls will block until possible to execute and then return.

```ruby
client = HCloud::Client.new(access_token: "my_token", rate_limit: true)

# At least one request has to be made to enable the rate limiter
client.rate_limiter.limit # => nil
client.rate_limiter.remaining # => nil
client.rate_limiter.reset # => nil

HCloud::Server.create(...)

client.rate_limiter.limit # => 3600
client.rate_limiter.remaining # => 3599
client.rate_limiter.reset # => 2023-01-01 00:00:00 +0100

# Make a bunch of requests

client.rate_limiter.remaining # => 0

servers = HCloud::Server.all # Will block until remaining requests have regenerated (1 second by default) and then execute
ssh_keys = HCloud::SSHKey.all # Will block until remaining requests have regenerated (1 second by default) and then execute
```

Since rate limits are per hour and per project, using multiple clients at the same time will interfere with the rate limiting mechanism.
To prevent this, wrap client calls in a loop that retries the call after it fails with a `HCloud::RateLimitExceeded` error.

### Compression

Enable compression by passing an appropriate `compression` option to `HCloud::Client.new`.
Current supported options are `nil`, `"gzip"`, and `"brotli"`.
Compression is disabled by default.

```ruby
client = HCloud::Client.new(access_token: "my_access_token", compression: "gzip")
```

To use Brotli compression, you need to install the `brotli` gem (at least version 0.3.0):

```ruby
gem "brotli"
```

## Storage boxes

Please note that storage boxes require a different API endpoint.
The endpoint for **storage boxes** is `https://api.hetzner.com/v1`.
The endpoint for **all other resources** is `https://api.hetzner.cloud/v1`.
The storage box endpoint is passed as an extra argument to the `HCloud::Client`, see [Endpoint](#endpoint) for more information.

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

`HCloud::Client` also accepts alternate endpoints:

```ruby
client = HCloud::Client.new(
  endpoint: "https://myproxy/v1",
  storage_box_endpoint: "https://myproxy/storage-box/v1",
  access_token: "my_access_token",
)
```

## Releasing

To release a new version, update the version number in `lib/hcloud/version.rb`, update the changelog, commit the files and create a git tag starting with `v`, and push it to the repository.
Github Actions will automatically run the test suite, build the `.gem` file and push it to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/floriandejonckheere/hcloud](https://github.com/floriandejonckheere/hcloud). 

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
