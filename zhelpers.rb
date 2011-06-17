
# TODO: send these to the Guide: http://zguide.zeromq.org/main:translate
module ZMQ
  module Helpers

    # Retrieve full version string
    # http://zguide.zeromq.org/page:all#Version-Reporting
    def version
      z_arr = ZMQ.version
      "ZMQ version #{z_arr[0]}.#{z_arr[1]}.#{z_arr[2]}"
    end

    # Send #close to all sockets and context when INT signal received
    def s_interrupted(socket_list, context)
      trap("INT") do
        puts "W: interrupt received, exiting..."
        socket_list.each {|s| s.close}
        context.close
        exit
      end
    end

    module_function :version, :s_interrupted
  end
end
