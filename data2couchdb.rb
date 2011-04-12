# 2011 Kamil Pluszczewicz k.pluszczewicz at gmail.com
# This programme gets file with json records and put them into couchdb
#
# USAGE:
# $: data2couch datafile couchdbserver

require 'rubygems'
require 'net/http'
require 'digest/sha1'

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
      #raise e
    end
  end
end


twitts = File.new ARGV[0]
db_url = ARGV[1]

uri = URI.parse db_url

server = Couch::Server.new(uri.host, uri.port)
server.put(uri.path, "")

twitts.each_line { |line|
	doc_id = Digest::SHA1.hexdigest line
	doc = line
	server.put("/test/#{doc_id}", doc)
}
