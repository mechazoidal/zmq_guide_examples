require 'zmq'
require './zhelpers'

context = ZMQ::Context.new(1)

server = context.socket(ZMQ::REP)
server.bind('tcp://*:5555')

ZMQ::Helpers::s_interrupted([server], context)

while true
  request = server.recv
  server.send('World')
end
