require 'zmq'
require '../trollop'

opts = Trollop::options do
  opt :count, "how many updates", :default=>100
  opt :zipcode, "which zipcode", :default=>"10001"
end

context = ZMQ::Context.new(1)

# socket to talk to server
puts "Collecting updates from weather server.."
subscriber = context.socket(ZMQ::SUB)
subscriber.connect ("tcp://localhost:5556")

# subscribe to zipcode, default is NYC, 10001
subscriber.setsockopt(ZMQ::SUBSCRIBE, opts[:zipcode])

# process 100 updates
total_temp = 0
trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  puts "Average temperature for zipcode '#{opts[:zipcode]}' was #{total_temp / opts[:count]}F"
  subscriber.close
  context.close
  exit
end

1.upto(opts[:count]) do |update_nbr|
  zipcode, temperature, relhumidity = subscriber.recv.split.map(&:to_i)
  total_temp += temperature
  print"."
end

puts ""
puts "Average temperature for zipcode '#{opts[:zipcode]}' was #{total_temp / opts[:count]}F"

subscriber.close
context.close
