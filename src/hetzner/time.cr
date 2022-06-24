require "./version"
require "./zone"
require "json"
require "http/client"

module Hetzner
  module DNS
    class CustomTime
      property time : Time

      def initialize(pull : JSON::PullParser)
        @time = from_string(pull.read_string)
      end

      def initialize(string : String)
        @time = from_string(string)
      end

      private def from_string(str : String)
        Time.parse_utc(str, "%Y-%m-%d %H:%M:%S %z %^Z")
      rescue Time::Format::Error
        Time.parse_utc(str, "%Y-%m-%d %H:%M:%S.%N %z %^Z")
      end

      def to_json(json : JSON::Builder)
        json.string to_s
      end

      def to_s(fraction_digits = 3)
        Time::Format::RFC_3339.format(time, fraction_digits: fraction_digits)
      end
    end

    # 2020-04-07 01:54:01.995329285 +0000 UTC m=+634.121701602
    struct CustomTimeWithMonotonicClock
      def initialize(pull : JSON::PullParser)
        time, monotonic = pull.read_string.split("m=+")
        sec, nano = monotonic.split('.')

        @time = CustomTime.new(time)
        @monotonic = Time::Span.new(seconds: sec.to_i, nanoseconds: nano.to_i)
      end

      def to_json(json : JSON::Builder)
        json.string "#{time.to_s(fraction_digits: 9)} m=+#{monotonic.to_f}"
      end

      property time : CustomTime
      property monotonic : Time::Span
    end
  end
end
