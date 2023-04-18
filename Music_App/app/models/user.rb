class User < ApplicationRecord
    validates :email, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true 
    validates :password, allow_nil: true

    attr_reader :password 

    # Hashes the "password" inputted from the user and saves it in the db as password_digest
    def password=(password)
        self.password_digest = BCrypt::Password.create(password)
        @password = password
        # storing the password in an instance variable allows us to validate it 
    end

    # Verifies if the input password is the same password stored in db
    def is_password?(password)  #this is_password? method is called on the user instance
        BCrypt::Password.new(password_digest).is_password?(password) #this is_password? is called on the BCrypt::Password instance
    end

    # Find a user by their credentials. Will return a user only if email and password exist
    def self.find_by_credentials(email, password)
        user = User.find_by(email: :email)
        return nil if user.nil?
        
        if user && user.is_password?(password)
            user 
        else 
            nil 
        end
    end

    # Before the validation is run, ensure that the user has a token
    before_validation :ensure_session_token

    # Create the method for this ensure_session_token
    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end

    def reset_session_token
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end 

    def generate_unique_session_token
        SecureRandom::urlsafe_base64
    end
    
end
