class Link < ApplicationRecord
    validates :user_id, presence: true
    validates :original_url, presence: true, format: { with: /\A[https:\/\/]/i, notice: "Please include \"https://\" in your url."}

    belongs_to :user
end
