module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
    accepts_nested_attributes_for :votes
  end

  def rating
    self.votes.sum(:rating)
  end
end