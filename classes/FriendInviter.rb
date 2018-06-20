##
#--
# Author: Astik Anand
#++

require "json"
require "json-schema"

#
# This class intends to serve the purpose of finding friends
# within a given range of distance, with friends list from a
# json file.
#++
class FriendInviter

    ##
    # Method to convert degrees to radians
    #
    # Input: value in degrees
    # Output: value in radians
    #    
	def degreesToRadians(degrees)
		return degrees * Math::PI / 180
	end


    ##
    # Method to read list of friends from a json file
    #
    # Input: a json file
    # Output: list of friends data in json format if file is found false otherwise
    #
	def readFriendsListFromJsonFile(file_name)
        begin
			file = File.read(file_name)
			friends_list_data = JSON.parse(file)
		rescue
			return false
		end
	end

    

    ##
    # Method to check if json list data is valid 
    #
    # Input: list of friends data in json format & schema to validate with
    # Output: true if validated with schema false otherwise
    #
    def validateFriendsListJsonData(friends_list_data, schema)
    	if(friends_list_data.length == 0)
    		return false
    	end

    	JSON::Validator.validate(schema, friends_list_data, :list => true)
    end



	##
	# Method to calculate distance b/w 2 geo points
	#
	# Using Haversine formula to calculate distance b/w 2 geo points
	# a = sin²(Δφ/2) + sin²(Δλ/2) * cos φ1 * cos φ2 
    # c = 2 * atan2( √a, √(1−a) )
    # d = R * c
    # 
    # Fact: -90 <= latitude <= 90 and -180 <= longitude <=180
    #
    # Input: longitudes and lattitudes of 2 geocoordinates
    # Output: distance b/w 2 given geocoordinates in kms
    #
	def distanceInKmBetweenEarthCoordinates(latitude1, longitude1, latitude2, longitude2)
		earth_radius_in_km = 6371

		lattitude_difference_in_radians = degreesToRadians(latitude2 - latitude1)
		longitude_difference_in_radians = degreesToRadians(longitude2 - longitude1)

		latitude1_in_radians = degreesToRadians(latitude1)
		latitude2_in_radians = degreesToRadians(latitude2)

		a = Math.sin(lattitude_difference_in_radians/2) * Math.sin(lattitude_difference_in_radians/2) +
		        Math.sin(longitude_difference_in_radians/2) * Math.sin(longitude_difference_in_radians/2) * 
		        Math.cos(latitude1_in_radians) * Math.cos(latitude2_in_radians)
		
		c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
		
		return earth_radius_in_km * c
	end


	##
	# Method to find list of friends within a certain distance from home
	# 
	# Input: list of friends datat as json & distance_range 
	# Output: friends list within range sorted by user_id 
	#
	def friendsListWithinDistance(friends_list_data, distance_range_in_km)
		latitude1 = 12.9611159
		longitude1 = 77.6362214

		list_of_friends_within_range = []

		for friend in friends_list_data
			latitude2 = friend["latitude"].to_f
		    longitude2 = friend["longitude"].to_f

		    distance_from_home = distanceInKmBetweenEarthCoordinates(latitude1, longitude1, latitude2, longitude2)


			if(distance_from_home <= distance_range_in_km)
				list_of_friends_within_range.push(user_id: friend['user_id'], name: friend['name'])
			end
		end

		sorted_list_of_friends_within_range = list_of_friends_within_range.sort_by{|friend| friend[:user_id]}

		return sorted_list_of_friends_within_range
	end

end
