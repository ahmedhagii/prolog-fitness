#!/usr/bin/ruby

require 'net/http'
require 'json'
require 'uri'
require 'timeout'


list = ARGV[0].split(" ")

data = {
    "weight"=> list[0],
    "fat"=> list[1],
    "al"=> list[2],
    "bulking"=> list[3],
    "meals"=> list[4]
}


ans = {}
counter = 0
while true do
	# puts
	counter += 1
	full_url = 'http://localhost:5000/reply'
	uri = URI.parse(full_url)
	postData = Net::HTTP.post_form(uri, data)
	if(!postData.body.index("Time limit").nil? && counter < 20)
		next
	end
	# puts(postData.body)

	if(!postData.body.index("Time limit").nil?)
		ans = []
		break
	else
		resp = postData.body[postData.body.index('{')..postData.body.length]
		res = JSON.parse(resp)
		# puts res["schedule"].to_json
		res["schedule"].to_json
		ans = res["schedule"].to_json
		break
	end
end
puts ans
# res["schedule"].to_json
