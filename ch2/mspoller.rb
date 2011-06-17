require 'ffi'
require 'ffi-rzmq'

#require 'zmq'
require '../zhelpers'
context = ZMQ::Context.new(1)

# connect to task ventilator
receiver = context.socket(ZMQ::PULL)
receiver.connect('tcp://localhost:5557')

# connect to weather server
subscriber = context.socket(ZMQ::SUB)
subscriber.connect('tcp://localhost:5556')
subscriber.setsockopt(ZMQ::SUBSCRIBE, '10001')

# Initialize a poll set
#poller = ZMQ::Poller.new
#poller.register(receiver, ZMQ::POLLIN)
#poller.register(subscriber, ZMQ::POLLIN)

poller = ZMQ::Poller.new
poller.register(receiver, ZMQ::POLLIN)
poller.register(subscriber, ZMQ::POLLIN)

#ZMQ::Helpers.s_interrupted([receiver, subscriber, poller], context)

trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  subscriber.close
  receiver.close
  poller.close
  context.close
  exit
end

while true
  poller.poll(:blocking)
  poller.readables.each do |socket|
    if socket === receiver
      message = socket.recv
      # process task
    elsif socket === subscriber
      # process weather update
    end
  end
end
