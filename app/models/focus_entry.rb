class FocusEntry < ApplicationRecord
  before_save :normalize_optional_text_fields

  validates :entry_date, presence: true, uniqueness: true
  validates :primary_focus, presence: true
  validates :non_achievement_reason, presence: true, if: -> { achieved == false }

  scope :reviewed, -> { where.not(achieved: nil) }
  scope :unreviewed, -> { where(achieved: nil) }
  scope :recent, -> { order(entry_date: :desc) }

  def self.for_date(date)
    find_by(entry_date: date)
  end

  def self.today
    for_date(Date.current)
  end

  def normalize_optional_text_fields
    self.anticipated_blockers = anticipated_blockers.presence
    self.non_achievement_reason = non_achievement_reason.presence
    self.ai_reflection = ai_reflection.presence
  end
  private :normalize_optional_text_fields

  def morning_complete?
    primary_focus.present?
  end

  def reviewed?
    !achieved.nil?
  end
end
