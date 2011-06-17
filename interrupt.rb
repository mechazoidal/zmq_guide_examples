require 'zmq'
context = ZMQ::Context.new(1)

server = context.socket(ZMQ::REP)
server.bind('tcp://*:5555')

trap("INT") do
  puts "W: interrupt received, killling server..."
  server.close
  context.close
  exit
end

while true
  request = server.recv
  server.send('World')
end
