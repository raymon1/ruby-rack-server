require "spec_helper"

describe Rrserver::Server do
	let(:server) { Rrserver::Server.new(application, sockets) }
	let(:application) { double(:application) }
	let(:socket) { double(:socket) }
	let(:sockets) { [socket] }

	describe "#run" do
		it "handles interrupt" do
			expect(server).to receive(:monitor) { raise Interrupt.new }
			expect(Rrserver.logger).to receive(:log).with("Interrupted")
			server.run
		end
	end

	describe "#monitor" do
		it "selects then accepts and handles a connection" do
			io = double(:io)
			socket = double(:socket)
			http = double(:http)

			expect(Rrserver::HTTP).to receive(:new).with(socket, application) { http }
			expect(http).to receive(:handle)

			expect(IO).to receive(:select).with(sockets) { io }
			expect(io).to receive(:accept) { socket }
			expect(socket).to receive(:close)

			server.monitor
		end
	end

end	