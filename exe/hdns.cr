require "../src/hetzner/dns"

client = Hetzner::DNS::Client.new ENV["HDNS_TOKEN"]
# puts client.zones.all.to_json
puts client.records.all.to_json
