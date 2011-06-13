require 'zmq'

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
  #puts "sending update: #{update.to_s}"
  publisher.send(update)
end
