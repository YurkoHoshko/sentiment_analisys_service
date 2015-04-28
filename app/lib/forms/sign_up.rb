module Forms
  class SignUp < Base
    attribute :username,              String
    attribute :password,              String
    attribute :password_confirmation, String

    validates :username, :password, :password_confirmation, presence: true
    validates :username, :password, length: { in: 6..20 }
    validate  :passwords_match, :unique_username

    def model_fields
      [:username, :password]
    end

    private
    def passwords_match
      if password != password_confirmation
        errors[:password] << "does not match confirmation"
      end
    end

    def unique_username
      errors[:username] << "is already taken"
    end
  end
end