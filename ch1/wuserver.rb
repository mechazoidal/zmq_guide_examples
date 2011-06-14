require 'zmq'
require '../trollop'

opts = Trollop::options do
  opt :verbose, "say a lot", :default=>false
end

context = ZMQ::Context.new(1)
publisher = context.socket(ZMQ::PUB)
publisher.bind("tcp://*:5556")
publisher.bind("ipc://weather.ipc")

trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  publisher.close
  context.close
  exit
end

while true
  # get values
  zipcode = rand(100000)
  temperature = rand(215) - 80
  relhumidity = rand(50) + 10

  update = "%05d %d %d" % [zipcode, temperature, relhumidity]

  # NOTE: This can trigger a "deadlock; recursive locking" ThreadError if you
  # fire an interrupt.
  if opts[:verbose]
    $stdout << "sending update: #{update.to_s}\n" 
    $stdout.flush
  end
  publisher.send(update)
end
