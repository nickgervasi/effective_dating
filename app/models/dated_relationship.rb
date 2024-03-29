# This entire class is an implementation detail. Ideally nothing should be calling this besides code generated by the
# EffectiveDated concern.

class DatedRelationship < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :feature, polymorphic: true

  #alias_method :effective_date, :effect_from
  #alias_method :effective_date=, :effect_from=

  def self.features_overlapping(start_date, end_date)
    where('effect_from IS NULL OR effect_from <= ?', end_date).
      where('effect_to IS NULL OR effect_to >= ?', start_date).
      includes(:feature).map(&:feature)
  end

  def self.features_between(start_date, end_date)
    where('effect_from >= ?', start_date).
      where('effect_to <= ?', end_date).
      includes(:feature).map(&:feature)
  end

  def active?(date)
    (effect_from.nil? || effect_from <= date) && (effect_to.nil? || effect_to >= date)
  end

  def effective_dates
    [effect_from, effect_to]
  end
end
