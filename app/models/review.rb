class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  field :trip_id,       type: Integer
  field :driver_id,     type: Integer
  field :passenger_id,  type: Integer
  field :rating,        type: Integer
  field :content,       type: String
  field :status,        type: String, default: "pending"

  index({ trip_id: 1 })
  index({ driver_id: 1 })

  # Validations for the review model to make sure tht reviews are from 1 to 5
  validates :rating, numericality: { only_integer: true, in: 1..5 }
  validates :content, presence: true
end
