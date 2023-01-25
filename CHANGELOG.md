# Changelog

## Unreleased

- Add pricing for Primary IPs
- Add server Metadata resource

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
