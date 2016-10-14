require "rrserver/cli"
require "rrserver/logger"
require "rrserver/version"

module Rrserver
	def self.logger
		@logger ||= Rrserver::Logger.new
	end
end
