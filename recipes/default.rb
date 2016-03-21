# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

include_recipe "fluentd"

# Configuration files for all sources
node['exception-notifier']['sources'].each do |source|
  attrs = {
    "type" => "tail",
    "format" => "multiline",
    "format_firstline" => source['format_firstline'],
    "format1" => source['format'],
    "path" => source['path'],
    "pos_file" => "/tmp/fluentd-#{source['tag']}.pos",
    "tag" => source['tag'],
    "multiline_flush_interval" => source['flush_interval'] || '5s'
  }

  template source['tag'] do
    cookbook "fluentd"
    path     "/etc/fluent/config.d/source_#{source['tag']}.conf"
    owner    node['exception-notifier']['fluentd']['user']
    group    node['exception-notifier']['fluentd']['group']
    helpers(Fluentd::Helpers)
    source   "plugin_source.conf.erb"
    variables({ :attributes => attrs })
    notifies :restart, "service[fluent]", :delayed
  end
end

# Configuration files for all matches
node['exception-notifier']['matches'].each do |match|
  attrs = {
    "match" => match['tag'],
    "type" => "copy",
    "store" => []
  }
  match.regexp.each do |regexp|
    attrs["store"] << {
      "type" => "grepcounter",
      "count_interval" => "3",
      "input_key" => match['input_key'],
      "regexp" => regexp,
      "threshold" => "1",
      "add_tag_prefix" => "exception",
      "delimiter" => "\\n",
      "hostname" => "${hostname}"
    }
  end

  template match['tag'] do
    cookbook "fluentd"
    path     "/etc/fluent/config.d/match_#{match['tag']}.conf"
    owner    node['exception-notifier']['fluentd']['user']
    group    node['exception-notifier']['fluentd']['group']
    helpers(Fluentd::Helpers)
    source   "plugin_match.conf.erb"
    variables({ :match => attrs.delete('match'), :attributes => attrs })
    notifies :restart, "service[fluent]", :delayed
  end

  # Add a new match file with the configurations to send emails
  smtp = node["exception-notifier"]["smtp"]
  attrs = {
    "match" => "exception.#{match['tag']}",
    "type" => "copy",
    "store" => [
      {
        "type" => "stdout"
      },
      {
        "type" => "mail",
        "host" => smtp["host"],
        "port" => smtp["port"],
        "user" => smtp["user"],
        "password" => smtp["password"],
        "enable_starttls_auto" => smtp["enable_starttls_auto"],
        "from" => smtp["from"],
        "to" => smtp["to"],
        "subject" => "'Exception detected on %s'",
        "subject_out_keys" => "hostname",
        "message" => "%s",
        "message_out_keys" => match['input_key']
      }
    ]
  }
  template match['tag'] do
    cookbook "fluentd"
    path     "/etc/fluent/config.d/smtp_#{match['tag']}.conf"
    owner    node['exception-notifier']['fluentd']['user']
    group    node['exception-notifier']['fluentd']['group']
    helpers(Fluentd::Helpers)
    source   "plugin_match.conf.erb"
    variables({ :match => attrs.delete('match'), :attributes => attrs })
    notifies :restart, "service[fluent]", :delayed
  end
end
