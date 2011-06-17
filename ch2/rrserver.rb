require 'zmq'
require '../zhelpers'

context = ZMQ::Context.new(1)
socket = context.socket(ZMQ::REP)
socket.connect('tcp://localhost:55560')

ZMQ::Helpers::s_interrupted([socket], context)

loop do
  message = socket.recv
  puts "received request: #{message}"
  socket.send("World")
end
