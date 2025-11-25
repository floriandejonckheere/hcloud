# Changelog

## Unreleased

### Added

- Add `update_records` action to `HCloud::RRSet`

### Changed

### Removed

### Fixed

## HCloud v4.3.0 (2025-11-17)

### Added

- Implement Zones
- Implement Zone actions
- Implement RRSets
- Implement RRSet actions

### Removed

- Removed global `ActiveSupport::Inflector` inflections 

## HCloud v4.2.0 (2025-09-24)

### Added

- Add `locations` attribute to `ServerType`

### Changed

- Add deprecation warning for `ServerType#deprecation`

## HCloud v4.1.0 (2025-09-02)

### Added

- Add `category` attribute to `ServerType`

### Changed

- Allow certain `create` and `delete` methods to return a `HCloud::Action` instance instead of a resource, as returned by the API (e.g. Storage Box API)

## HCloud v4.0.0 (2025-07-26)

### Added

- Add `LoadBalancerPublicInterfaceDisabled` error class
- Implement Storage Boxes
- Implement Storage Box Types
- Implement Storage Box Subaccounts
- Implement Storage Box Subaccount actions

### Changed

- Change `HCloud::Collection#where` interface: now accepts a string instead of a hash to allow for more complex queries
  - For example: `HCloud::Server.where(label_selector: "env=prod,app!=web")`
- Cache total entries in `HCloud::Collection` when calling #count

### Fixed

- Fix a zero division error in the rate limiter when rate limit headers are not set
- Fix an error in the error parsing code when the error details are not present

## HCloud v3.0.0 (2024-11-25)

### Removed

- Remove `included_traffic` attribute from `ServerType`
- Remove `traffic` attribute from `Pricing`

## HCloud v2.2.1 (2024-08-30)

### Changed

- Add deprecation warning for `Pricing#floating_ip`

## HCloud v2.2.0 (2024-08-22)

### Added

- Add support for (de-)compression of HTTP requests

## HCloud v2.1.0 (2024-07-28)

### Added

- Add `included_traffic` attribute to `ServerType#prices` and `LoadBalancerType#prices`
- Add `price_per_tb_traffic` attribute to `ServerType#prices` and `LoadBalancerType#prices`

### Changed

- Add deprecation warning for `Pricing#traffic`
- Add deprecation warning for `ServerType#included_traffic`

### Fixed

- Fix crash on prices when using `Pricing` API

## HCloud v2.0.0 (2024-01-10)

### Removed

- Remove `deprecated` attribute from `ISO`

## HCloud v1.7.2 (2023-10-16)

### Added

- Add `deprecation` attribute to `ISO`

## HCloud v1.7.1 (2023-07-25)

### Changed

- Add deprecation warning for `HCloud::Action.all`

## HCloud v1.7.0 (2023-06-30)

### Added

- Add load balancer actions

## HCloud v1.6.1 (2023-06-22)

### Added

- Add `expose_routes_to_vswitch` attribute to `Network`

## HCloud v1.6.0 (2023-06-07)

### Added

- Add `deprecation` attribute to `ServerType`

### Changed

- Parse `private_net` attribute on `Server` as array
- Parse `public_net.firewalls` attribute on `Server` as array of objects with status (not array of `Firewall`s)

## HCloud v1.5.4 (2023-05-17)

### Changed

- Allow defining attributes on the fly

## HCloud v1.5.3 (2023-05-09)

### Added

- Add `included_traffic` attribute to `ServerType`

## HCloud v1.5.2 (2023-04-22)

### Added

- Add `architecture` attribute to `Image` and `ISO`

## HCloud v1.5.1 (2023-04-20)

### Added

- Add `Unavailable` error class
- Add `architecture` attribute to `ServerType`

## HCloud v1.5.0 (2023-02-01)

### Added

- Add pricing for Primary IPs
- Add server Metadata resource
- Add support for rate limits
- Add shorthand methods for `.first`, `.last`, `.count`, `.where`, `.sort`, `.each`, and `.empty?` on resource
- Add `label_selector:` argument to `HCloud::Collection`

### Changed

- `Action#resources` now returns a list of resources instead of a list of hashes
- Separate server protection entity from other protection entity (only server protection includes `rebuild`)

## HCloud v1.4.0 (2023-01-22)

### Added

- Implemented Primary IPs
- Implemented Primary IP Actions

### Changed

- Return the resource when calling `#create`, `#update` or `#delete`

### Fixed

- Allow calling `#update` with additional attributes to be updated
- Add additional primary IP mismatch errors:
  - `PrimaryIPAssigned`
  - `PrimaryIPDatacenterMismatch`
  - `PrimaryIPVersionMismatch`

## HCloud v1.3.1 (2022-02-06)

### Added

- Add `user_data` attribute to `Server`

## HCloud v1.3.0 (2022-02-04)

### Added

- Implemented Load Balancers
- Implemented Load Balancer Types

## HCloud v1.2.0 (2022-02-01)

### Added

- Implemented Networks
- Implemented Network Actions
- Implemented Pricing
- Implemented Certificates
- Implemented Certificate Actions

## HCloud v1.1.0 (2022-01-30)

### Added

- Implemented Firewall Actions

## HCloud v1.0.0 (2022-01-16)

Initial release
