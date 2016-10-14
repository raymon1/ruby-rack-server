require "rack"
require "slop"
require "socket"
require "time"
require "uri"


require "rrserver/cli"
require "rrserver/http"
require "rrserver/launcher"
require "rrserver/logger"
require "rrserver/server"
require "rrserver/version"

module Rrserver
	def self.logger
		@logger ||= Rrserver::Logger.new
	end
end
