require 'zmq'
require '../zhelpers'

context = ZMQ::Context.new(1)

frontend = Context.socket(ZMQ::ROUTER) # XREP
backend = context.socket(ZMQ::DEALER) # XREQ

frontend.bind('tcp://*:5559')
backend.bind('tcp://*:5560')

# poller
ZMQ::Helpers::s_interrupted([frontend, backend, poller], context)
