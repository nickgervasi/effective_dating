class DatedRelationship::HasMany < DatedRelationship
  def self.features_on(date)
    where('effect_from IS NULL OR effect_from <= ?', date).
      where('effect_to IS NULL OR effect_to >= ?', date).
      includes(:feature).map(&:feature)
  end
end
