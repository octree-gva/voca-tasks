require "rake"
module Decidim
  module Voca
    module Rpc
      class Health
        include ::VocaDecidim

        ##
        # Return just a string without any caculations. 
        # This is done to test succesfull interaction through RPC
        def ping
          "pong"
        end
        
      end
    end
  end
end
