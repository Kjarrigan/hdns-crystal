require "./version"
require "./zone"
require "json"
require "http/client"

module Hetzner
  module DNS
    struct Meta
      include JSON::Serializable

      property pagination : Pagination
    end

    struct Pagination
      include JSON::Serializable

      property per_page : Int32
      property next_page : Int32
    end

    class Error < Exception; end

    class Client
      def initialize(@token : String, @url = "https://dns.hetzner.com/api")
      end

      def zones
        ZoneClient.new(self)
      end

      def get(path)
        resp = HTTP::Client.get(@url + path, headers: default_headers)
        raise Error.new("GET #{path} failed with #{resp.status_code}") unless resp.success?

        resp.body
      end

      private def default_headers
        HTTP::Headers{"Content-Type" => "application/json", "Auth-API-Token" => @token}
      end
    end
  end
end
