require 'buildar'

Buildar.new do |b|
  b.use_git = true
  b.version_file = 'VERSION'
  b.gemspec.name = 'port-monitor'
  b.gemspec.summary = 'poll a TCP port for status changes'
  b.gemspec.homepage = 'https://github.com/rickhull/port-monitor'
  b.gemspec.author = 'Rick Hull'
  b.gemspec.license = 'MIT'
  b.gemspec.description = 'poll a TCP port for status changes'
  b.gemspec.files = %w{rakefile.rb bin/port-monitor lib/port_monitor.rb}
end
