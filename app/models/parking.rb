class Parking < ApplicationRecord
  belongs_to :user, optional: true

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
    puts "----"
    puts self.parking_type
    puts "----"

    if self.amount.blank? && self.start_at.present? && self.end_at.present?
      if self.user.blank?
        self.amount = calculate_guest_term_amount
      elsif self.parking_type == "short-term"
        self.amount = calculate_short_term_amount
      else self.parking_type == "long-term"
        self.amount = calculate_long_term_amount
      end
    end
  end

  def calculate_guest_term_amount
    if duration <= 60
      self.amount = 200
    else
      self.amount = ( (duration - 60) / 30).ceil * 100 + 200
    end
  end

  def calculate_short_term_amount
    if duration <= 60
      self.amount = 200
    else
      self.amount = ( (duration - 60) / 30).ceil * 50 + 200
    end
  end

  def calculate_long_term_amount
    if duration <= 60 * 6
      self.amount = 1200
    else
      self.amount = 1600 * ( (duration - 60 * 24) / (60 * 24)).ceil + 1600
    end
  end

end
