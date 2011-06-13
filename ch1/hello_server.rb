require 'zmq'

context = ZMQ::Context.new(1)
serv_socket = context.socket(ZMQ::REP)
serv_socket.bind("tcp://*:5555")

trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  serv_socket.close
  context.close
  exit
end

while true
  incoming = serv_socket.recv
  puts "Received 'hello'"
  sleep(1)
  serv_socket.send("World")
end
