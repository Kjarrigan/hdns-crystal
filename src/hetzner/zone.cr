require "./version"
require "json"
require "http/client"

module Hetzner
  module DNS
    struct Zone
      include JSON::Serializable

      property id : String
      property created : CustomTime
      property modified : CustomTime
      property legacy_dns_host : String
      property legacy_ns : Array(String)
      property name : String
      property ns : Array(String)
      property owner : String
      property paused : Bool
      property permission : String
      property project : String
      property registrar : String
      property status : String # Enum?
      property ttl : Int32
      property verified : CustomTimeWithMonotonicClock
      property records_count : Int32
      property is_secondary_dns : Bool
      property txt_verification : ZoneTxtVerification
    end

    struct ZoneTxtVerification
      include JSON::Serializable

      property name : String
      property token : String
    end

    struct ZonesResponse
      include JSON::Serializable

      property zones : Array(Zone)
      property meta : Meta
    end

    struct ZoneResponse
      include JSON::Serializable

      property zone : Zone
    end

    class ZoneClient
      def initialize(@client : Client)
      end

      def all
        json = @client.get("/v1/zones")
        resp = ZonesResponse.from_json(json)
        resp.zones
      rescue e
        puts e
        puts e.backtrace.join("\n")
        puts json
      end
    end
  end
end
