require 'zmq'
context = ZMQ::Context.new(1)

# connect to task ventilator
receiver = context.socket(ZMQ::PULL)
receiver.connect('tcp://localhost:5557')

# connect to weather server
subscriber = context.socket(ZMQ::SUB)
subscriber.connect('tcp://localhost:5556')
subscriber.setsockopt(ZMQ::SUBSCR, '10001')

trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  subscriber.close
  receiver.close
  context.close
  exit
end

while true
  if(receiver_msg = receiver.recv(ZMQ::NOBLOCK) && !receiver_msg.empty?)
    # process task
  end

  if subscriber_msg = subscriber.recv(ZMQ::NOBLOCK) && !subscriber_msg.empty?
    # process weather update
  end

  # no activity, so sleep for 1 msec
  sleep(0.001)
end
