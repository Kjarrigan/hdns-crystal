require "./version"
require "json"
require "http/client"

module Hetzner
  module DNS
    struct Zone
      include JSON::Serializable

      property id : String
      property created : Time
      property modified : Time
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
      property verified : Time
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
        resp = ZonesResponse.from_json(@client.get("/v1/zones"))
        resp.zones
      end
    end
  end
end
