require 'zmq'
require '../zhelpers'

context = ZMQ::Context.new(1)

puts ZMQ::Helpers::version
puts "Connecting to hello world server..."
requester = context.socket(ZMQ::REQ)
requester.connect("tcp://localhost:5555")

trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  requester.close
  context.close
  exit
end

0.upto(9) do |request_nbr|
  puts "Sending request #{request_nbr}..."
  requester.send "Hello"

  reply = requester.recv
  puts "Received reply #{request_nbr}: [#{reply}]"
end
requester.close
context.close

