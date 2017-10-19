# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  short_url  :string           not null
#  long_url   :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord

  validates :user_id, :short_url, :long_url, presence: true
  validates :short_url, uniqueness: true

  def self.random_code
    code = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(short_url: code)
      code = SecureRandom.urlsafe_base64
    end
    code
  end

  # ShortenedUrl::make_shortened_url: User, string => ShortenedUrl instance
  def self.make_shortened_url(user, long_url)
    shortened = ShortenedUrl.new(user_id: user.id, long_url: long_url)
    shortened.short_url = ShortenedUrl.random_code
    shortened.save
    shortened
  end

  def num_clicks
    visits.count
  end

  def num_uniques
    visitors
  end

  def num_recent_uniques
    ShortenedUrl.where(["created_at > ? AND url_id = ?", 10.minutes.ago, @user_id])
  end

  belongs_to :submitter,
           primary_key:  :id,
           foreign_key:  :user_id,
           class_name:   :User

  has_many :visits,
          primary_key: :id,
          foreign_key: :user_id,
          class_name: :Visit

  has_many :visitors,
  Proc.new {distinct},
  through: :visits,
  source: :user
end
