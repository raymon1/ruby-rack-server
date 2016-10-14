require "spec_helper"

describe Rrserver::HTTP do
  let(:content) { "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
  let(:socket) { double(:socket) }
  let(:application) { double(:application) }
  let(:http) { Rrserver::HTTP.new(socket, application) }

  describe "#parse" do
    it "matches a valid request line and headers" do
      expect(socket).to receive(:gets) { "POST /search?query=sample HTTP/1.1#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Accept-Encoding: gzip#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Accept-Language: en#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Content-Type: text/html#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Content-Length: #{content.length}#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { Rrserver::HTTP::CRLF }
      expect(socket).to receive(:read) { content }

      env = http.parse
      expect(env["HTTP_VERSION"]).to eql("HTTP/1.1")
      expect(env["REQUEST_URI"]).to eql("/search?query=sample")
      expect(env["REQUEST_METHOD"]).to eql("POST")
      expect(env["PATH_INFO"]).to eql("/search")
      expect(env["QUERY_STRING"]).to eql("query=sample")
      expect(env["SERVER_PORT"]).to eql(80)
      expect(env["SERVER_NAME"]).to eql("localhost")
      expect(env["CONTENT_TYPE"]).to eql("text/html")
      expect(env["CONTENT_LENGTH"]).to eql(content.length)
      expect(env["HTTP_ACCEPT_ENCODING"]).to eql("gzip")
      expect(env["HTTP_ACCEPT_LANGUAGE"]).to eql("en")
    end
  end

  describe "#handle" do
    it "handles the request with the application" do
      expect(Time).to receive(:now) { double(:time, httpdate: "Thu, 01 Jan 1970 00:00:00 GMT") }
      expect(application).to receive(:call) { [200, { "Content-Type" => "text/html" }, ["<html></html>"]] }

      expect(socket).to receive(:gets) { "GET / HTTP/1.1#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Accept-Encoding: gzip#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Accept-Language: en#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Content-Type: text/html#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { "Content-Length: #{content.length}#{Rrserver::HTTP::CRLF}" }
      expect(socket).to receive(:gets) { Rrserver::HTTP::CRLF }
      expect(socket).to receive(:read) { content }

      expect(socket).to receive(:write).with("HTTP/1.1 200 OK#{Rrserver::HTTP::CRLF}")
      expect(socket).to receive(:write).with("Date: Thu, 01 Jan 1970 00:00:00 GMT#{Rrserver::HTTP::CRLF}")
      expect(socket).to receive(:write).with("Connection: close#{Rrserver::HTTP::CRLF}")
      expect(socket).to receive(:write).with("Content-Type: text/html#{Rrserver::HTTP::CRLF}")
      expect(socket).to receive(:write).with(Rrserver::HTTP::CRLF)
      expect(socket).to receive(:write).with("<html></html>")

      expect(Rrserver.logger).to receive(:log).with("[Thu, 01 Jan 1970 00:00:00 GMT] 'GET / HTTP/1.1' 200")

      http.handle
    end
  end

end