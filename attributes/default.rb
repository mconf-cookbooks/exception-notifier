# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

default['exception-notifier']['sources']            = []
default['exception-notifier']['matches']            = []
default['exception-notifier']['smtp']               = {}
default['exception-notifier']['send_notifications'] = true
default['exception-notifier']['fluentd']['user']    = node['fluentd']['user'] || 'fluent'
default['exception-notifier']['fluentd']['group']   = node['fluentd']['group'] || 'fluent'
default['exception-notifier']['fluentd']['log_path'] = "/var/log/fluent"

# logrotate options
# by default keeps one log file per day, during 1 month
default['exception-notifier']['logrotate']['frequency'] = 'daily'
default['exception-notifier']['logrotate']['rotate']    = 30
default['exception-notifier']['logrotate']['size']      = nil
