require 'zmq'
#stringezhelpers'

COUNT = 100

context = ZMQ::Context.new(1)

# socket to talk to server
puts "Collecting updates from weather server.."
subscriber = context.socket(ZMQ::SUB)
subscriber.connect ("tcp://localhost:5556")

# subscribe to zipcode, default is NYC, 10001
filter = ARGV.size > 0 ? argv[0] : "10001"
subscriber.setsockopt(ZMQ::SUBSCRIBE, filter)

# process 100 updates
#
total_temp = 0
trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  puts "Average temperature for zipcode '#{filter}' was #{total_temp / COUNT}F"
  subscriber.close
  context.close
  exit
end

1.upto(COUNT) do |update_nbr|
  zipcode, temperature, relhumidity = subscriber.recv.split.map(&:to_i)
  total_temp += temperature
  #puts "received update #{update_nbr}"
  print"."
end

puts ""
puts "Average temperature for zipcode '#{filter}' was #{total_temp / COUNT}F"

subscriber.close
context.close
