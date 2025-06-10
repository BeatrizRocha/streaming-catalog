class User < ApplicationRecord
    has_secure_password validations: false

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL_REGEX }

    with_options if: -> { provider == "local" } do
      validates :password, presence: true, length: { minimum: 6 }
      validates :password_confirmation, presence: true, on: :create
      validates :uid, absence: true
    end
  
    with_options if: -> { provider != "local" } do
      validates :uid, presence: true
      validates :password_digest, absence: true
      validates :uid, uniqueness: { scope: :provider }
    end
  
    def self.find_or_create_from_oauth(auth_hash)
      user = User.find_by(provider: auth_hash['provider'], uid: auth_hash['uid'])
      if user
        user
      else
        User.create!(
          provider: auth_hash['provider'],
          uid: auth_hash['uid'],
          email: auth_hash['info']['email'],
          name: auth_hash['info']['name'],
          password_digest: nil,
        )
      end
    end

    def self.authenticate(email, password)
      user = find_by(email: email)
      user if user&.authenticate(password)
    end
end
