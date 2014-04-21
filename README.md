# sidekiq-gelf

Enables Sidekiq logging to a GELF-supported server, such as Graylog2.

## Usage

``` ruby
# Replace the sidekiq logger with gelf-rb and set the formatter
# to include important logging information.
# These arguments are passed through to gelf-rb.
Sidekiq::Logging::GELF.hook!('127.0.0.1', 12201, 'LAN', facility: "my-application")
```