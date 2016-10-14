module Rrserver
	class Server
		def initialize(application, sockets)
			@application = application
			@sockets = sockets
		end

		def run
			loop do 
				begin 
					monitor
				rescue Interrupt
					Rrserver.logger.log("Interrupted")
					return
				end
			end
		end

		def monitor
			selections = IO.select(@sockets)
			io, = selections
			begin
				socket, = io.accept
				http = Rrserver::HTTP::new(socket, @application)
				http.handle
			ensure
				socket.close
			end
		end

	end
end