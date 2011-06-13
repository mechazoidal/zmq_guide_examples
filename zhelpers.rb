
# TODO: send these to the Guide: http://zguide.zeromq.org/main:translate
module ZMQ
  module Helpers
    # http://zguide.zeromq.org/page:all#Version-Reporting
    def version
      z_arr = ZMQ.version
      "ZMQ version #{z_arr[0]}.#{z_arr[1]}.#{z_arr[2]}"
    end
    module_function :version
  end
end
