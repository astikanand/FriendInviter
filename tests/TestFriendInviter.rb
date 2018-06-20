##
#--
# Author: Astik Anand
#
# Unit tests for the FriendInviter
#++

require 'rspec'
require_relative '../classes/FriendInviter'
require_relative '../modules/FriendSchemaModule'

include FriendSchema



describe FriendInviter do 
	## 
	# Some common needs before starting the tests
	#
	before { 
		@friend_inviter = FriendInviter.new()
		@friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/friends.json")
		@sorted_list_of_friends_within_range = [] 
	}

    ##
    # Testcases for the Method: readFriendsListFromJsonFile
    #
    # Input: a json file of friends list
    # Output: true or false depending on whther file is found or not or is empty
    #
	it "should give error if file is not found" do
		expect(@friend_inviter.readFriendsListFromJsonFile("../input_json/friendsxyz.json")).to eq false
	end

	it "should give error if file is found but empty" do
		expect(@friend_inviter.readFriendsListFromJsonFile("../input_json/empty_friends.json")).to eq false
	end

	it "should not give error if file is found" do
		expect(@friend_inviter.readFriendsListFromJsonFile("../input_json/friends.json")).not_to eq false
	end


    ##
    # Testcases for the Method: validateFriendsListJsonData
    #
    # Input: friend list in json format & schema to validate with
    # Output: true if validated with schema false otherwise
    #
	it "should give error if there is no friends in json file" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/no_friends.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq false
	end

	it "should give error if any field is missing in any of record in data" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/missing_field_friends.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq false
	end

	it "should give error if any field's type is mismatched in any of record in data" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/type_mismatching_friends.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq false
	end

	it "should return true if data in json file is valid" do 
		expect(@friend_inviter.validateFriendsListJsonData(@friends_list_data, SCHEMA)).to eq true
	end

	it "should return error if in json data longitude is > 180" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/longitude_greater_than_180.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq false
	end

	it "should return error if in json data longitude is < -180" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/longitude_lesser_than_minus_180.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq false
	end

	it "should return error if in json data lattitude is > 90" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/lattitude_greater_than_90.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq false
	end

	it "should return error if in json data lattitude is < -90" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/lattitude_lesser_than_minus_90.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq false
	end

	it "should return true if in json data longitude is = 180" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/longitude_equal_to_180.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq true
	end

	it "should return true if in json data longitude is = -180" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/longitude_equal_to_minus_180.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq true
	end

	it "should return true if in json data lattitude is = 90" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/lattitude_equal_to_90.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq true
	end

	it "should return true if in json data lattitude is = -90" do 
		friends_list_data = @friend_inviter.readFriendsListFromJsonFile("../input_json/lattitude_equal_to_minus_90.json")
		expect(@friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)).to eq true
	end


    ##
    # Testcases for the Method: distanceInKmBetweenEarthCoordinates
    #
    # Input: longitudes and lattitudes of 2 geocoordinates
    # Output: distance b/w 2 given geocoordinates in kms
    # 
    # Fact: -90 <= latitude <= 90 and -180 <= longitude <=180
    #  
	it "should return distance in km when geoocordinates of 2 points are passed" do
	    expect(@friend_inviter.distanceInKmBetweenEarthCoordinates(20,40,-45,120)).to eq 10815.395723230396
	end

	it "should return distance in km from equator" do
	    expect(@friend_inviter.distanceInKmBetweenEarthCoordinates(20,40,0,0)).to eq 4887.929603082412
	end

	it "should return distance in km from North pole" do
	    expect(@friend_inviter.distanceInKmBetweenEarthCoordinates(20,40,90,0)).to eq 7783.644865119111
	end

	it "should return distance in km from South pole" do
	    expect(@friend_inviter.distanceInKmBetweenEarthCoordinates(20,40,-90,0)).to eq 12231.441930901457
	end



 

    ##
    # Testcase for the Method: friendsListWithinDistance
    #
    # Input: friends list in json format
    # Output: Sorted list of friends a/c to user_id in given distance range
    #
	it "should find all the 11 friends within 100 km range from given file" do
		@sorted_list_of_friends_within_range.push(user_id: 4, name: "Ian")
		@sorted_list_of_friends_within_range.push(user_id: 5, name: "Nora")
		@sorted_list_of_friends_within_range.push(user_id: 6, name: "Theresa")
		@sorted_list_of_friends_within_range.push(user_id: 10, name: "Georgina")
		@sorted_list_of_friends_within_range.push(user_id: 11, name: "Richard")
		@sorted_list_of_friends_within_range.push(user_id: 12, name: "Chris")
		@sorted_list_of_friends_within_range.push(user_id: 15, name: "Michael")
		@sorted_list_of_friends_within_range.push(user_id: 16, name: "Ian")
		@sorted_list_of_friends_within_range.push(user_id: 25, name: "David")
		@sorted_list_of_friends_within_range.push(user_id: 31, name: "Alan")
		@sorted_list_of_friends_within_range.push(user_id: 39, name: "Lisa")
		expect(@friend_inviter.friendsListWithinDistance(@friends_list_data, 100)).to eq @sorted_list_of_friends_within_range
	end


	it "should find no friends within 10 km range" do
		expect(@friend_inviter.friendsListWithinDistance(@friends_list_data, 10)).to eq @sorted_list_of_friends_within_range
	end

	it "should find no friends within neggative distance range" do
		expect(@friend_inviter.friendsListWithinDistance(@friends_list_data, -10)).to eq @sorted_list_of_friends_within_range
	end

	
end
