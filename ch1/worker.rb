require 'zmq'

context = ZMQ::Context.new(1)

# socket to receive on
receiver = context.socket(ZMQ::PULL)
receiver.connect("tcp://localhost:5557")

#socket to send to
sender = context.socket(ZMQ::PUSH)
sender.connect("tcp://localhost:5558")

trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  receiver.close
  sender.close
  context.close
  exit
end

while true
  msec = receiver.recv

  # simple progress indocator
  $stdout << "#{msec}."
  $stdout.flush

  # Do The Work(tm)
  sleep(msec.to_f / 1000)

  # Send results to sink
  sender.send("")
end
