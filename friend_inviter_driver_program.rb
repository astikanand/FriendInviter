##
#--
# Author: Astik Anand
#
# A driver program to run the FriendInviter
#++

require_relative 'classes/FriendInviter'
require_relative 'modules/FriendSchemaModule'

include FriendSchema

friend_inviter = FriendInviter.new()
friends_list_data = friend_inviter.readFriendsListFromJsonFile("input_json/friends.json")


if friends_list_data

    valid_data = friend_inviter.validateFriendsListJsonData(friends_list_data, SCHEMA)

    if valid_data
		sorted_list_of_friends_within_range = friend_inviter.friendsListWithinDistance(friends_list_data, 100)

		print "\n======== Result =========\n\n"
		if sorted_list_of_friends_within_range.length > 0
		    print "Here are list of friends:\n"
		    for friend in sorted_list_of_friends_within_range
				print "#{friend[:user_id]}  #{friend[:name]}  #{friend[:distance]} \n"
			end
		else
		    print "No friends found within the given distance range.\n"
		end
	else
		print "Json data provided in the file is invalid \n"
    end

else
	print "Either the json file is not found or empty. \n"
end