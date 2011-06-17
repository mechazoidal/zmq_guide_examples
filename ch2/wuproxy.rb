# Weather proxy device
#
# Scott Francis <scott(at)kurokoproject(dot)org>

require 'zmq'
require '../zhelpers'

context = ZMQ::Context.new(1)

# This is where the weather server sits
frontend = context.socket(ZMQ::SUB)
frontend.connect("tcp://192.168.55.210:5556")

# This is our public endpoint for subscribers
backend = context.socket(ZMQ::PUB)
backend.bind("tcp://10.1.1.0:8100")

# Subscribe to everything
frontend.setsockopt(ZMQ::SUBSCRIBE, '')

ZMQ::Helpers::s_interrupted([frontend, backend], context)

# Shunt messages out to our own subscribers
while true
  message = frontend.recv
  more = frontend.getsockopt(ZMQ::RCVMORE)
  if more
    backend.send(message, ZMQ::SNDMORE)
  else
    backend.send(message)
  end
end
