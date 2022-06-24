require "./version"
require "json"
require "http/client"

module Hetzner
  module DNS
    struct Record
      include JSON::Serializable

      property id : String
      property type : String # Enum?
      property name : String
      property value : String
      property ttl : Int32?
      property zone_id : String
      property created : CustomTime
      property modified : CustomTime
    end

    struct RecordsResponse
      include JSON::Serializable

      property records : Array(Record)
    end

    struct RecordResponse
      include JSON::Serializable

      property record : Record
    end

    class RecordClient
      def initialize(@client : Client)
      end

      # In theory this endpoint has per_page/page params but in practice it does not work, it'll
      # always return all records. The zone_id filter seems to work though...
      # PS: It doesn't even have a meta/pagination section in the docs
      def all(zone_id : Nil | String = nil, page : Nil | Int32 = nil, per_page : Nil | Int32 = nil)
        if page || per_page
          raise Error.new("invalid params. page & per_page do not work for the /records endpoint")
        end

        json = @client.get("/v1/records")
        resp = RecordsResponse.from_json(json)
        resp.records
      rescue e
        puts e
        puts e.backtrace.join("\n")
        puts json
      end
    end
  end
end
