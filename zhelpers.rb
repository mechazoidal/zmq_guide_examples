
# TODO: send these to the Guide: http://zguide.zeromq.org/main:translate
module ZMQ
  module Helpers

    # http://zguide.zeromq.org/page:all#Version-Reporting
    def version
      z_arr = ZMQ.version
      "ZMQ version #{z_arr[0]}.#{z_arr[1]}.#{z_arr[2]}"
    end

    def exit_on_int(sockets, context)
      trap("INT") do
        # to catch and handle CTRL-C safely..
        puts "Exiting.."
        sockets.each {|s| s.close}
        context.close
        exit
      end
    end

    module_function :version, :exit_on_int
  end
end
