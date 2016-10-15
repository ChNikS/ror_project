class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def author_of?(object)
    object.user_id == id
  end

  def can_vote?(object)
    !author_of?(object) && !voted?(object)
  end

  def voted?(object)
    object.votes.where(user: self).exists?
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization
    email = auth.info[:email]
    name = auth.info[:name]
    user = User.where(email: email).first if email
    
    if user
      user.create_authorization(auth.provider, auth.uid)
    else
      password = Devise.friendly_token[0, 20]
      if email.blank?
        return User.new
      else 
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.create_authorization(auth.provider, auth.uid)
      end
    end
    user
  end

  def create_authorization(provider, uid)
    self.authorizations.create(provider: provider, uid: uid)
  end

  def generate(user_email)
    password = Devise.friendly_token[0, 20]
    user = User.create!(email: user_email, password: password, password_confirmation: password)
    user
  end

end
