##
#--
# Author: Astik Anand
#
# This module tells about the schema of each friend
# in friends list json file.
# 
# The schema is used to check the validity of data
#
# Schema is also enforced to check this
# Fact: -90 <= latitude <= 90 and -180 <= longitude <=180
#++
module FriendSchema
    SCHEMA = {
	    "type"=>"object",
	    "required" => ["latitude", "user_id", "name", "longitude", ],
	    "properties" => {
	        "latitude" => {
	            "type" => "string",
	            "pattern" => "^-?[1-8]?[0-9](\.[0-9]+)?$|^-?9[0]$"
	        },
	        "user_id" => {
	            "type" => "integer",
	        },
	        "name" => {
	            "type" => "string",
	        },
	        "longitude" => {
	            "type" => "string",
	            "pattern" => "^-?[1]?[0-7]?[0-9](\.[0-9]+)?$|^-?[8-9][0-9](\.[0-9]+)?$|^-?[1][8][0]$"
	        }
	    }
    }
end


