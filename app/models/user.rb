class User < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
  
  validates :email, presence: true, uniqueness: true
  validates :google_id, presence: true, uniqueness: true
  validates :name, presence: true
  
  def self.from_google_oauth(auth_data)
    user = find_by(google_id: auth_data['sub'])
    
    unless user
      user = create!(
        google_id: auth_data['sub'],
        email: auth_data['email'],
        name: auth_data['name'],
        avatar_url: auth_data['picture']
      )
    end
    
    user
  end
end