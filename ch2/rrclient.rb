require 'zmq'
require '../zhelpers'

context = ZMQ::Context.new(1)
socket = context.socket(ZMQ::REQ)
socket.connect('tcp://localhost:5559')

ZMQ::Helpers::s_interrupted([socket], context)

10.times do |request|
  string = "Hello #{request}"
  socket.send(string)
  puts "Sending string [#{string}]"
  message = socket.recv
  puts "Received reply #{request}[#{message}]"
end
