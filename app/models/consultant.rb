class Consultant < ApplicationRecord
  include EffectiveDated

  dated_has_many :projects
  #dated_has_one :hourly_rate

  #has_many :projects
  # has_many :hourly_rates
  # has_many :dated_relationships, as: :owner
  # has_many :projects, through: :dated_relationships, source: :feature, source_type: 'Project'

end
