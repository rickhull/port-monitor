require 'socket'
require 'timeout'

class PortMonitor
  def self.timestamp(time = Time.now)
    time.strftime('%Y-%m-%d %H:%M:%S')
  end

  # friendly helper
  #
  def self.status(host, port)
    PortMonitor.new(host, port).status
  end

  attr_reader :host, :port
  attr_accessor :delay

  def initialize(host, port, delay = 1)
    @host = host
    @port = port.to_i
    @delay = delay.to_i
  end

  def up?
    begin
      Timeout.timeout(@delay) { !TCPSocket.new(@host, @port).close }
    rescue SystemCallError, Timeout::Error # ECONNREFUSED, etc
      false
    rescue SocketError => e                # DNS, unknown host
      warn "#{e}"
      false
    rescue Exception => e
      warn "#{e.class.name} #{e}"
      false
    end
  end

  def status(is_up = :unknown)
    is_up = self.up? if is_up == :unknown
    "#{self.class.timestamp} #{@host}:#{@port} is #{is_up ? 'UP' : 'DOWN'}"
  end

  def run
    $stdout.sync = true
    puts "Ctrl-c (SIGINT) to quit..."
    puts
    Signal.trap("INT") {
      puts 
      puts "-- Trapped SIGINT --"
      puts self.status(up?)
      puts "DONE"
      exit 0
    }
    loop {
      is_up = self.up?
      puts self.status(is_up)
      while is_up == self.up?
        print '.'
        sleep @delay
      end
      puts
    }
  end
end

if __FILE__ == $0
  PortMonitor.new('github.com', 80).run 
end
