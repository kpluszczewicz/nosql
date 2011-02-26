require 'rubygems'
require 'net/http'
require 'digest/sha1'

Gem.path.push "/home/studinf/kpluszcz/.gems"

module Couch

  class Server
    def initialize(host, port, options = nil)
      @host = host
      @port = port
      @options = options
    end

    def delete(uri)
      request(Net::HTTP::Delete.new(uri))
    end

    def get(uri)
      request(Net::HTTP::Get.new(uri))
    end

    def put(uri, json)
      req = Net::HTTP::Put.new(uri)
      req["content-type"] = "application/json"
      req.body = json
      request(req)
    end

    def post(uri, json)
      req = Net::HTTP::Post.new(uri)
      req["content-type"] = "application/json"
      req.body = json
      request(req)
    end

    def request(req)
      res = Net::HTTP.start(@host, @port) { |http|http.request(req) }
      unless res.kind_of?(Net::HTTPSuccess)
        handle_error(req, res)
      end
      res
    end

    private

    def handle_error(req, res)
      e = RuntimeError.new("#{res.code}:#{res.message}\nMETHOD:#{req.method}\nURI:#{req.path}\n#{res.body}")
      raise e
    end
  end
end

server = Couch::Server.new("sigma.ug.edu.pl", "14017")
server.put("/kpluszcz_test/", "")

twitts = File.new "chunk.json"

twitts.each_line { |line|
	doc_id = Digest::SHA1.hexdigest line
	doc = line
	server.put("/test/#{doc_id}", doc)
}
