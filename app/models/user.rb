class User < ApplicationRecord
  # Relations
  has_many :answers, inverse_of: :respondent
  has_many :surveys, inverse_of: :surveyor

  # https://github.com/binarylogic/authlogic
  acts_as_authentic do |auth|
    auth.crypto_provider                         = Authlogic::CryptoProviders::BCrypt
    auth.validates_format_of_email_field_options = { :with => Authlogic::Regex.email_nonascii }
  end

  # <b>To get the user full name</b>
  def name
    "#{first_name} #{last_name}"
  end
end
