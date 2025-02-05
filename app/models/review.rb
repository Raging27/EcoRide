class Review
  include Mongoid::Document
  include Mongoid::Timestamps

  # Define the fields for the review document
  field :trip_id,       type: Integer
  field :driver_id,     type: Integer
  field :passenger_id,  type: Integer
  field :rating,        type: Integer
  field :content,       type: String
  field :status,        type: String, default: "pending"

  # Optional: add indexes to improve query performance
  index({ trip_id: 1 })
  index({ driver_id: 1 })
end
