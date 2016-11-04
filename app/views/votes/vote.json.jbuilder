json.votable_type @votable.class.name.downcase
json.votable_id @votable.id
json.total @votable.total
json.user_voted current_user.voted?(@votable)
json.user_can_vote !current_user.author_of?(@votable)