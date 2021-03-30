# RELEASE NOTES

### main

**Notes**

**Bug Fixes**

- Fix incompatibility with Ruby 3.0 and kwargs: https://github.com/fastruby/harvesting/pull/68

### Version 0.5.1 - January 14, 2021

**Notes**
- Add support for Codecov so that we can track code coverage over time in the
library: https://github.com/fastruby/harvesting/pull/59

**Bug Fixes**
- Fix incompatibility with Ruby 3.0: https://github.com/fastruby/harvesting/pull/64
- Relax `http` dependency declaration so that we can `bundle install` with more
modern versions of that gem: https://github.com/fastruby/harvesting/pull/63
- Fix issue when trying to remove an entity that is not removable:
https://github.com/fastruby/harvesting/pull/61

### Version 0.5.0 - September 3, 2020

**Notes**
- Changed behavior of `client.clients` so that it returns an instance of `Harvesting::Models::Clients` instead of an `Array`: https://github.com/fastruby/harvesting/pull/39

**Bug Fixes**
- Add support for Harvesting::RateLimitExceeded instead of a JSON::ParserError: https://github.com/fastruby/harvesting/pull/57
- Add support for RequestNotFound instead of a JSON::ParserError: https://github.com/fastruby/harvesting/pull/54

### Version 0.4.0 - June 6, 2020

**Notes**
- Added Ruby 2.5.1 to version matrix in Travis: https://github.com/fastruby/harvesting/pull/31
- Associated time entries for project: https://github.com/fastruby/harvesting/pull/32
- Add require forwardable in havest_record_collection model: https://github.com/fastruby/harvesting/pull/40
- Add syntax highlighting to readme examples: https://github.com/fastruby/harvesting/pull/41
- Rename the client key as harvest_client to avoid confusion: https://github.com/fastruby/harvesting/pull/43
- Update rake requirement from ~> 10.0 to ~> 13.0: https://github.com/fastruby/harvesting/pull/44
- Bump ffi from 1.9.23 to 1.12.2: https://github.com/fastruby/harvesting/pull/45
- Ability to supply filter options to the invoice end point and a model for line items on an invoice.: https://github.com/fastruby/harvesting/pull/46

**Bug Fixes**

- Complete pending test: https://github.com/fastruby/harvesting/pull/28
- Fixed Code Climate link: https://github.com/fastruby/harvesting/pull/38


### Version 0.3.0 - Jan 22, 2019

**Notes**

- Support for users: https://github.com/fastruby/harvesting/pull/9
- Support for fetching single records: https://github.com/fastruby/harvesting/pull/14 and https://github.com/fastruby/harvesting/pull/22
- Nested models make it easier to access data: https://github.com/fastruby/harvesting/pull/15
- Better architecture for collections: https://github.com/fastruby/harvesting/pull/18

**Bug Fixes**

- Correct pagination support: https://github.com/fastruby/harvesting/pull/17
- Added documentation: https://github.com/fastruby/harvesting/pull/30

### Version 0.2.0 - Oct 18, 2018

**Notes**

- More documentation in README.md
- Adds ability to access user associated with time entries: https://github.com/fastruby/harvesting/pull/3
- Adds support for Docker for development: https://github.com/fastruby/harvesting/pull/1

**Bug Fixes**

- Fixes issues with specs: https://github.com/fastruby/harvesting/pull/2
- Fixed https://github.com/fastruby/harvesting/issues/6 with https://github.com/fastruby/harvesting/pull/7

## Version 0.1.0 - Sep 04, 2018

**Notes**

- Initial release
