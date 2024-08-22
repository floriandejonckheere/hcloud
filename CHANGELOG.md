# Changelog

## HCloud v2.2.0 (2024-08-22)

- Add support for (de-)compression of HTTP requests

## HCloud v2.1.0 (2024-07-28)

- Add `included_traffic` attribute to `ServerType#prices` and `LoadBalancerType#prices`
- Add `price_per_tb_traffic` attribute to `ServerType#prices` and `LoadBalancerType#prices`
- Add deprecation warning for `Pricing#traffic`
- Add deprecation warning for `ServerType#included_traffic`
- Fix crash on prices when using `Pricing` API

## HCloud v2.0.0 (2024-01-10)

- Remove `deprecated` attribute from `ISO`

## HCloud v1.7.2 (2023-10-16)

- Add `deprecation` attribute to `ISO`

## HCloud v1.7.1 (2023-07-25)

- Add deprecation warning for `HCloud::Action.all`

## HCloud v1.7.0 (2023-06-30)

- Add load balancer actions

## HCloud v1.6.1 (2023-06-22)

- Add `expose_routes_to_vswitch` attribute to `Network`

## HCloud v1.6.0 (2023-06-07)

- Add `deprecation` attribute to `ServerType`
- Parse `private_net` attribute on `Server` as array
- Parse `public_net.firewalls` attribute on `Server` as array of objects with status (not array of `Firewall`s)

## HCloud v1.5.4 (2023-05-17)

- Allow defining attributes on the fly

## HCloud v1.5.3 (2023-05-09)

- Add `included_traffic` attribute to `ServerType`

## HCloud v1.5.2 (2023-04-22)

- Add `architecture` attribute to `Image` and `ISO`

## HCloud v1.5.1 (2023-04-20)

- Add `Unavailable` error class
- Add `architecture` attribute to `ServerType`

## HCloud v1.5.0 (2023-02-01)

- Add pricing for Primary IPs
- Add server Metadata resource
- Add support for rate limits
- `Action#resources` now returns a list of resources instead of a list of hashes
- Separate server protection entity from other protection entity (only server protection includes `rebuild`)
- Add shorthand methods for `.first`, `.last`, `.count`, `.where`, `.sort`, `.each`, and `.empty?` on resource
- Add `label_selector:` argument to `HCloud::Collection`

## HCloud v1.4.0 (2023-01-22)

- Implemented Primary IPs
- Implemented Primary IP Actions
- Allow calling `#update` with additional attributes to be updated
- Return the resource when calling `#create`, `#update` or `#delete`
- Add additional primary IP mismatch errors:
  - `PrimaryIPAssigned`
  - `PrimaryIPDatacenterMismatch`
  - `PrimaryIPVersionMismatch`

## HCloud v1.3.1 (2022-02-06)

- Add missing `Server#user_data`

## HCloud v1.3.0 (2022-02-04)

- Implemented Load Balancers
- Implemented Load Balancer Types

## HCloud v1.2.0 (2022-02-01)

- Implemented Networks
- Implemented Network Actions
- Implemented Pricing
- Implemented Certificates
- Implemented Certificate Actions

## HCloud v1.1.0 (2022-01-30)

- Implemented Firewall Actions

## HCloud v1.0.0 (2022-01-16)

Initial release
