module VotesHelper
  def delete_vote_class(obj)
    "#{obj.class.name.underscore}-del-#{obj.id} #{'hidden' unless current_user.voted_of?(obj)}"
  end

  def up_down_vote_class(obj)
    "#{obj.class.name.underscore}-up-down-#{obj.id} #{'hidden' if current_user.voted_of?(obj)}"
  end

  def delete_vote_path(obj)
    current_user.voted_of?(obj) ? vote_path(current_user.find_vote(obj)) : '#'
  end
end