#!/usr/bin/env ruby

$stdout.sync = true

def usage(msg = nil)
  if msg
    puts "ERROR: #{msg}"
    puts
  end
  puts <<EOF
USAGE:
  port_monitor.rb $HOST:$PORT [$DELAY]

    $DELAY defaults to 2 seconds
EOF
  exit 1
end

require 'port_monitor'

DEFAULT_DELAY = 2

host = ARGV.shift || usage
splitted = host.split(':')

case splitted.length
when 1
  # we just have a host
  port = ARGV.shift || usage("No target port was specified")
when 2
  host, port = *splitted 
else
  usage("Could not understand #{host}")
end

delay = (ARGV.shift || DEFAULT_DELAY).to_i
delay = DEFAULT_DELAY if delay < 1

PortMonitor.new(host, port, delay).run

