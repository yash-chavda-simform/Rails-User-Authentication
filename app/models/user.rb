class User < ApplicationRecord
  validates :email, uniqueness: true
  validates :first_name, :last_name, :email, :password, presence: true
  has_secure_password
  has_secure_token :remember_digest
  attr_accessor :remember_token
  
  def remember(user)
    self.remember_token = User.generate_token   #get random string from generate_token class method
    update_attribute(:remember_digest, User.digest(remember_token)) #find min cost and then create hash val based on min cost and stord in datbase
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
  
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
    
  def self.generate_token
    SecureRandom.urlsafe_base64
  end
end
