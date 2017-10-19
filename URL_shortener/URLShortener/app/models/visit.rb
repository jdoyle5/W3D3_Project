# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  url_id     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Visit < ApplicationRecord
  validates :user_id, :url_id, presence: true

  def self.record_visit!(user, shortened_url)
    visit = Visit.new(user_id: user.id, url_id: shortened_url.id)
    visit.save!
  end

  belongs_to :user,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User

  

end
