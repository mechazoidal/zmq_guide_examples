require 'zmq'

context = ZMQ::Context.new(1)

receiver = context.socket(ZMQ::PULL)
receiver.bind("tcp://*:5558")

# wait for start of batch
receiver.recv
tstart = Time.now

trap("INT") do
  # to catch and handle CTRL-C safely..
  puts "Exiting.."
  receiver.close
  context.close
  exit
end

# Process 100 confirmations
100.times do |task_nbr|
  receiver.recv
  $stdout << ((task_nbr % 10 == 0) ? ':' : '.')
  $stdout.flush
end

# calculate and report duration of batch
tend = Time.now
total_msec = (tend-tstart) * 1000
puts "Total elapsed time: #{total_msec} msec"

receiver.close
context.close
