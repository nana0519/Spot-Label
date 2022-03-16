class EndUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :spots, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 自分がフォローしている人
  has_many :following_end_user, through: :follower, source: :followed
  # 自分をフォローしている人
  has_many :follower_end_user, through: :followed, source: :follower

  has_one_attached :profile_image

  validates :name, length: { maximum: 20 }, presence: true
  validates :introduction, length: { maximum: 500 }
  # プロフィール画像のデフォルト設定
  def get_profile_image
    profile_image.attached? ? profile_image : "no_image.jpg"
  end

  # フォローする
  def follow(end_user)
    follower.create(followed_id: end_user.id)
  end
  # フォローを外す
  def unfollow(end_user)
    follower.find_by(followed_id: end_user.id).destroy
  end
  # フォローしているかを確認する
  def following?(end_user)
    following_end_user.include?(end_user)
  end
  
  # ゲストログイン機能
  def self.guest
    find_or_create_by!(name: 'guestuser', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end
end
