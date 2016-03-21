# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

default['exception-notifier']['sources']          = []
default['exception-notifier']['matches']          = []
default['exception-notifier']['smtp']             = {}
default['exception-notifier']['fluentd']['user']  = node['fluentd']['user'] || 'fluent'
default['exception-notifier']['fluentd']['group'] = node['fluentd']['group'] || 'fluent'
