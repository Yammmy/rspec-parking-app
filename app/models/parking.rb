class Parking < ApplicationRecord
  validates_presence_of  :parking_type, :start_at
  validates_inclusion_of :parking_type, in: ["guest", "short-term", "long-term"]

  validate :validate_end_at_with_amount

  def validate_end_at_with_amount
    if ( end_at.present? && amount.blank? )
      errors.add(:amount, "The amount must exist if there is a end_at")
    end

    if ( end_at.blank? && amount.present? )
      errors.add(:end_at, "The end_at must exist if there is a amount")
    end
  end

  def duration
    ( end_at - start_at ) / 60
  end

  def calculate_amount
    if self.amount.blank? && self.start_at.present? && self.end_at.present?
      # self.amount = 9487
      if duration <= 60
        self.amount = 200
      else
        self.amount = ( (duration - 60) / 30).ceil * 100 + 200
      end
    end
  end

end
