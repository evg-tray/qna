class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  TYPES = %w(Answer Question)

  validates :votable_id, :votable_type, :rating, presence: true
  validates :votable_type, inclusion: { in: TYPES }
  validates :rating, inclusion: { in: [1, -1] }
  validate :author_validation, if: 'votable.present?'

  def author_validation
    errors.add(:user, "User is an author of object.") if user.author_of?(self.votable)
  end

  def self.types
    TYPES
  end
end
