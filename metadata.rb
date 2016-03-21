#
# This file is part of the Mconf project.
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#

name             'exception-notifier'
maintainer       'mconf'
maintainer_email 'mconf@mconf.org'
license          'MPL v2.0'
description      'Catch exceptions in log files and send emails with the content'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

%w{debian ubuntu}.each do |os|
  supports os
end

depends 'fluentd', '>= 0.0'
# requires fork 'https://github.com/mconf-cookbooks/fluentd-cookbook'

recipe 'exception-notifier::default', 'Installs fluentd to parse logs and notify in cases of exceptions'
