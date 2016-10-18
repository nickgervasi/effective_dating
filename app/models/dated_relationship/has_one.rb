class DatedRelationship::HasOne < DatedRelationship
  validate :dates_do_not_overlap

  after_save :update_siblings, unless: -> { @skip_callback }

  def self.feature_on(date)
    where('effect_from IS NULL OR effect_from <= ?', date).
      where('effect_to IS NULL OR effect_to >= ?', date).
      includes(:feature).map(&:feature).first
  end

  protected

  def update_sibling!(attrs)
    skip_callback = @skip_callback
    @skip_callback = true
    update_attributes!(attrs)
  ensure
    @skip_callback = skip_callback
  end

  private

  def dates_do_not_overlap
    if !effect_from.nil? && !effect_to.nil? && effect_from > effect_to
      errors.add(:effect_from, 'Effective dates cannot overlap')
      errors.add(:effect_to, 'Effective dates cannot overlap')
    end
  end

  def update_siblings
    if effect_from_changed?
      older_sibling.update_sibling!(effect_to: effect_from - 1.day)
    end

    if effect_to_changed?
      newer_sibling.update_sibling!(effect_from: effect_to + 1.day)
    end
  end

  def siblings
    DatedRelationship::HasOne.where(owner: owner, key: key).where.not(id: id).order(:effect_from)
  end

  def older_siblings
    siblings.where('effect_from IS NULL OR effect_from < ?', effect_from_was)
  end

  def older_sibling
    older_siblings.last
  end

  def newer_siblings
    siblings.where('effect_to IS NULL OR effect_from > ?', effect_from_was)
  end

  def newer_sibling
    older_siblings.first
  end
end
