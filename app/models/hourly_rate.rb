class HourlyRate < ApplicationRecord
  include EffectiveDated

  dated_belongs_to :consultant
  #belongs_to :consultant
end
