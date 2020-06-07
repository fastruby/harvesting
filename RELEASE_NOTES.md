# RELEASE NOTES

### master

**Notes**
- Changed behavior of `client.clients` so that it returns an instance of `Harvesting::Models::Clients` instead of an `Array`: https://github.com/ombulabs/harvesting/pull/39

### Version 0.4.0 - June 6, 2020

**Notes**
- Added Ruby 2.5.1 to version matrix in Travis: https://github.com/ombulabs/harvesting/pull/31
- Associated time entries for project: https://github.com/ombulabs/harvesting/pull/32
- Add require forwardable in havest_record_collection model: https://github.com/ombulabs/harvesting/pull/40
- Add syntax highlighting to readme examples: https://github.com/ombulabs/harvesting/pull/41
- Rename the client key as harvest_client to avoid confusion: https://github.com/ombulabs/harvesting/pull/43
- Update rake requirement from ~> 10.0 to ~> 13.0: https://github.com/ombulabs/harvesting/pull/44
- Bump ffi from 1.9.23 to 1.12.2: https://github.com/ombulabs/harvesting/pull/45
- Ability to supply filter options to the invoice end point and a model for line items on an invoice.: https://github.com/ombulabs/harvesting/pull/46

**Bug Fixes**

- Complete pending test: https://github.com/ombulabs/harvesting/pull/28
- Fixed Code Climate link: https://github.com/ombulabs/harvesting/pull/38


### Version 0.3.0 - Jan 22, 2019

**Notes**

- Support for users: https://github.com/ombulabs/harvesting/pull/9
- Support for fetching single records: https://github.com/ombulabs/harvesting/pull/14 and https://github.com/ombulabs/harvesting/pull/22
- Nested models make it easier to access data: https://github.com/ombulabs/harvesting/pull/15
- Better architecture for collections: https://github.com/ombulabs/harvesting/pull/18

**Bug Fixes**

- Correct pagination support: https://github.com/ombulabs/harvesting/pull/17
- Added documentation: https://github.com/ombulabs/harvesting/pull/30

### Version 0.2.0 - Oct 18, 2018

**Notes**

- More documentation in README.md
- Adds ability to access user associated with time entries: https://github.com/ombulabs/harvesting/pull/3
- Adds support for Docker for development: https://github.com/ombulabs/harvesting/pull/1

**Bug Fixes**

- Fixes issues with specs: https://github.com/ombulabs/harvesting/pull/2
- Fixed https://github.com/ombulabs/harvesting/issues/6 with https://github.com/ombulabs/harvesting/pull/7

## Version 0.1.0 - Sep 04, 2018

**Notes**

- Initial release
