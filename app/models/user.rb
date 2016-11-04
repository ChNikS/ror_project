class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  scope :profiles, ->(user_id) { where.not(id: user_id)}

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

  def self.send_daily_digest
    find_each.each do |user|
      DailyMailer.digest(user).deliver
    end
  end

  def subscribed?(question)
    subscriptions.where(question: question).exists?
  end

  def subscribe_to(question)
    subscriptions.create(question: question)
  end

  def unsubscribe_from(question)
    subscriptions.where(question: question).delete_all
  end
end
