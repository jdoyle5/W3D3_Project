# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_many :submitted_urls,
           primary_key: :id,
           foreign_key: :user_id,
           class_name: :ShortenedUrl

  
end
