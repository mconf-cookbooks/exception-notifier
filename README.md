exception-notifier Cookbook
===========================

Installs [fluentd](http://www.fluentd.org/) and configures it to match
exceptions in log files and send mail notifications with the stack trace.


Requirements
------------

This cookbook is tested with Chef 11 (latest version). It may work with or without
modification on newer versions of Chef, but Chef 11 is recommended.

Platform
--------

This cookbook is currently tested on Ubuntu 14.04.

Recipes
-------

#### default

Installs fluentd, the required plugins, and configure it to send notifications.


Usage
-----

#### exception-notifier::default

Include `exception-notifier` in your node's `run_list` along with the required attributes:

```json
{
  "name":"my_node",
  "exception-notifier": {
    "sources": [
      {
        "tag": "module-name.application-name",
        "format_firstline": "/^\\[(?<time>\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.\\d{3}Z)/",
        "format": "/^\\[(?<time>\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}.\\d{3}Z)[^\\]]*\\][ ]*(?<level>[^\\s:]+)[ :]*(?<message>.*)/",
        "path": "/var/www/application/log/production.log"
      }
    ],
    "matches": [
      {
        "tag": "module-name.application-name",
        "input_key": "message",
        "regexp": [
          "Error:"
        ]
      }
    ],
    "smtp": {
      "host": "email-smtp.us-east-1.amazonaws.com",
      "port": "587",
      "user": "my-secret-username",
      "password": "my-secret-password",
      "enable_starttls_auto": "true",
      "from": "notifier@my-domain.com",
      "to": "receivers@my-domain.com"
    }
  },
  "run_list": [
    "recipe[exception-notifier]"
  ]
}
```

ToDo
-----

* Allow the configuration of `format1`, `format2`, `format3`, etc., in sources.
* The error set in the subject is taken from the first regex specified in `matches`,
but the emails could be configured individually for each regex in the list.
