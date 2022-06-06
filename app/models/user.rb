# frozen_string_literal: true

# user class to hold the login & locked logic
class User < ApplicationRecord
  NAME_FORMAT = /\A[^`!@#$%\^&*+=]+\z/.freeze

  validates :username, presence: true, uniqueness: true
  validates_format_of :username, with: NAME_FORMAT, allow_blank: false
  validates_length_of :password, within: 6..128, allow_blank: false

  before_save :downcase_username

  def locked?
    locked
  end

  def authenticate(user_password)
    errors.add(:password, 'Invalid or Empty password') if user_password.blank?
    password.eql?(user_password) && unlocked!
  end

  def locked!
    update_columns(locked: true)
  end

  def unlocked!
    update_columns(locked: false, failed: 0)
  end

  def unlocked?
    !locked?
  end

  def downcase_username
    self.username = username.downcase
  end

  def increment_locked!
    update_columns(failed: failed + 1) && failed_attempt
  end

  def failed_attempt
    locked! if failed >= 3
  end
end
