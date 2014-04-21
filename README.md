# sidekiq-gelf

Enables Sidekiq logging to a GELF-supported server, such as Graylog2.

**Note:** at this time, you must use [this version](https://github.com/layervault/gelf-rb/tree/develop) of gelf-rb. The main version does not have formatted logging support yet.

## Usage

``` ruby
# Replace the sidekiq logger with gelf-rb and set the formatter
# to include important logging information.
# These arguments are passed through to gelf-rb.
Sidekiq::Logging::GELF.hook!('127.0.0.1', 12201, 'LAN', facility: "my-application")
```