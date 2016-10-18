class Project < ApplicationRecord
  include EffectiveDated

  def self.columns
    super.reject { |c| c.name == 'consultant_id' }
  end

  #has_one :dated_relationship, as: :feature
  #has_one :consultant, through: :dated_relationship, source: :owner, source_type: 'Consultant'
  dated_belongs_to :consultant
end
