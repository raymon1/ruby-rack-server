require "rrserver/logger"
require "rrserver/version"

module Rrserver
	def self.logger
		@logger ||= Rrserver::logger.new
	end
end
