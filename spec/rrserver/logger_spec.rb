require "spec_helper"

describe Rrserver::Logger do

	let(:stream) { double(:stream) }

	describe "#log" do
		it "proxies to stream" do
			logger = Rrserver::Logger.new(stream)
			expect(stream).to receive(:puts).with("hello!")
			logger.log("hello!")
		end
	end		
end