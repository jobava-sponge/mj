require 'savon'
require 'nori'

module Helpers
	class Soap
        def get_inst(institutie)
            client = Savon.client(endpoint: "http://portalquery.just.ro/Query.asmx", wsdl: "http://portalquery.just.ro/Query.asmx?WSDL", pretty_print_xml: true)
        	dstop = Time.now
        	message = {institutie: "#{institutie}", dataStop:dstop.strftime("%Y-%m-%d") }
        
        	response = client.call(:cautare_dosare,message: message)
        	res = response.hash
        	num_dosare = res[:envelope][:body][:cautare_dosare_response][:cautare_dosare_result][:dosar].length    

       		if num_dosare > 999
         		while num_dosare > 999
            		dstart = dstop - (60*60*24*10)
            		message = {institutie:"#{institutie}",dataStart:dstart.strftime("%Y-%m-%d"), dataStop:dstop.strftime("%Y-%m-%d") }
                    res = client.call(:cautare_dosare,message: message).hash
            		num_dosare = res[:envelope][:body][:cautare_dosare_response][:cautare_dosare_result][:dosar].length 
          		end
          		dstop = dstart
        	end
            return res[:envelope][:body][:cautare_dosare_response][:cautare_dosare_result][:dosar]
        end
	end
end

