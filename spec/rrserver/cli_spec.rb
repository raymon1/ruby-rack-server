require 'spec_helper'

describe Rrserver::CLI do
	let(:cli) { Rrserver::CLI.new() }
	let(:launcher) { double(:launcher) }

	describe "#parse" do
		%w(-v --version).each do |option|
			it "supports '#{option}' option" do
				expect(Rrserver.logger).to receive(:log).with Rrserver::VERSION
				cli.parse([option])
			end
		end

		%w(-h --help).each do |option|
			it "supports '#{option}' option" do
				expect(Rrserver.logger).to receive(:log).with <<~DEBUG
				usage: rrserver [options] [./config.ru]
				    -h, --help     help
				    -v, --version  version
				    -b, --bind     bind (default: 0.0.0.0)
				    -p, --port     port (default: 5000)
				    --backlog      backlog (default: 64)
				    --reuseaddr    reuseaddr (default: true)
				DEBUG
				cli.parse([option])
			end
		end

		it "build a launcher and executes run" do 
			expect(Rrserver::launcher).to receive(:new).with(4000, "0.0.0.0", true, 16, "./config.ru") { launcher }
			expect(launcher).to receive(:run)
			cli.parse(["--port", "4000", "--bind", "0.0.0.0", "--backlog", "16"])
		end
	end
end