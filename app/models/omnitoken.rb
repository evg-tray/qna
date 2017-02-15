class Omnitoken < ApplicationRecord
  belongs_to :user
  belongs_to :authorization

  validates :email, :token, presence: true

  after_create :send_confirmation_token

  def send_confirmation_token
    OmnitokenMailer.confirmation_email(self).deliver_now
  end
end
