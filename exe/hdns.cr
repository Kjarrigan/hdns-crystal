require "../src/hetzner/dns"

client = Hetzner::DNS::Client.new ENV["HDNS_TOKEN"]
p client.zones.all
