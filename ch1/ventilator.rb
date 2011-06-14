require 'zmq'

context = ZMQ::Context.new(1)

# socket to send on
sender = context.socket(ZMQ::PUSH)
sender.bind("tcp://*:5557")

trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  sender.close
  context.close
  exit
end

# We do this(in ch1) as a braindead way of synchronizing the workers
# (to avoid the "slow-joiners" ZMQ issue)
puts "Press enter when the workers are ready.."

$stdin.read(1)
puts 'Sending tasks to workers..'

# The first msg is '0' and signals the start of a batch

sender.send('0')

# Send 100 tasks
#
total_msec = 0 # total expected cost in msecs
100.times do
  workload = rand(100) + 1
  total_msec += workload
  $stdout << "#{workload}."
  sender.send(workload.to_s)
end

puts "Total expected cost: #{total_msec} msec"
Kernel.sleep(1) # give ZMQ time to deliver

sender.close
context.close
