require "spec_helper"

describe Rrserver::Launcher do
	let(:port) { 80 }
	let(:bind) { "0.0.0.0" }
	let(:backlog) { 64 }
	let(:reuseaddr) { true }
	let(:config) { "./spec/support/config.ru" }
	let(:socket) { double(:socket) }
	let(:server) { double(:server) }

	describe "#{run}" do
		it "configures a socket and proxies to server" do
			launcher = Rrserver::Launcher.new(port, bind, reuseaddr, backlog, config)

			expect(Rrserver.logger).to receive(:log).with("Rrserver")
			expect(Rrserver.logger).to receive(:log).with("0.0.0.0:80")
			expect(Socket).to receive(:new).with(:INET, :STREAM) { socket }
			expect(socket).to receive(:bind)
			expect(socket).to receive(:setsockopt).with(:SOL_SOCKET, :SO_REUSEADDR, reuseaddr)
			expect(socket).to receive(:listen).with(backlog)
			expect(socket).to receive(:close)

			expect(Rrserver::Server).to receive(:new) { server }
			expect(server).to receive(:run)

			launcher.run
		end
	end
end