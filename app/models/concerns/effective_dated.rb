module EffectiveDated
  extend ActiveSupport::Concern

  # included do
  #   has_many :dated_relationships, as: :owner
  # end

  module ClassMethods
    def dated_belongs_to(name)
      # relationship_name = "#{name}_dated_relationship".to_sym
      # # Should account for type here too
      # has_one relationship_name, class_name: 'DatedRelationship', as: :feature, autosave: true, inverse_of: :feature
      #
      # delegate :effect_from, :effect_to, :effective_dates, :active?, to: relationship_name, allow_nil: true
      #
      # define_method(:effect_from=) do |date|
      #   send("ensure_#{name}")
      #   send(relationship_name).send(:effect_from=, date)
      # end
      #
      # define_method(:effect_to=) do |date|
      #   send("ensure_#{name}")
      #   send(relationship_name).send(:effect_to=, date)
      # end
      #
      # define_method("#{name}=") do |owner|
      #   send("ensure_#{name}")
      #   send(relationship_name).send(:owner=, owner)
      # end
      #
      # define_method("#{name}_id=") do |owner_id|
      #   send("ensure_#{name}")
      #   send(relationship_name).send(:owner_type=, name.to_s.camelize)
      #   send(relationship_name).send(:owner_id=, owner_id)
      # end
      #
      # define_method("ensure_#{name}") do
      #   # TODO NG -- needs to account for key and type
      #   send(relationship_name) || send("build_#{relationship_name}", { feature: self, key: options[:inverse_of] })
      # end
      #
      # define_method(name) do
      #   send(relationship_name).try!(:owner)
      # end

      relationship_name = :dated_relationship
      # Should account for type here too
      has_one relationship_name, class_name: 'DatedRelationship', as: :feature, autosave: true, inverse_of: :feature

      delegate :effect_from, :effect_to, :effective_dates, :active?, to: relationship_name, allow_nil: true

      define_method(:effect_from=) do |date|
        send("ensure_#{name}")
        send(relationship_name).send(:effect_from=, date)
      end

      define_method(:effect_to=) do |date|
        send("ensure_#{name}")
        send(relationship_name).send(:effect_to=, date)
      end

      define_method("#{name}=") do |owner|
        send("ensure_#{name}")
        send(relationship_name).send(:owner=, owner)
      end

      define_method("#{name}_id=") do |owner_id|
        send("ensure_#{name}")
        send(relationship_name).send(:owner_type=, name.to_s.camelize)
        send(relationship_name).send(:owner_id=, owner_id)
      end

      define_method("ensure_#{name}") do
        # TODO NG -- needs to account for key and type
        send(relationship_name) || send("build_#{relationship_name}", { feature: self, key: options[:inverse_of] })
      end

      define_method(name) do
        send(relationship_name).try!(:owner)
      end
    end

    def dated_has_many(name)
      singular_name = name.to_s.singularize
      relationship_name = "#{singular_name}_dated_relationships".to_sym

      has_many relationship_name, -> { where(key: name) }, class_name: 'DatedRelationship::HasMany', as: :owner

      # According to http://guides.rubyonrails.org/association_basics.html#the-has-many-through-association
      # > Automatic deletion of join models is direct, no destroy callbacks are triggered.
      # That sounds too dangerous for our purpose
      #
      # has_many name, through: relationship_name, source: :feature, source_type: singular_name.camelize

      define_method("#{name}_on") do |date|
        send(relationship_name).features_on(date)
      end

      define_method("#{name}_overlapping") do |start_date, end_date|
        send(relationship_name).features_overlapping(start_date, end_date)
      end

      define_method("#{name}_between") do |start_date, end_date|
        send(relationship_name).features_between(start_date, end_date)
      end

      define_method("build_#{singular_name}") do |attributes = {}|
        singular_name.camelize.constantize.new.tap do |feature|
          feature.dated_relationship = send(relationship_name).build(feature: feature)
          feature.assign_attributes(attributes)
        end
      end
    end

    def dated_has_one(name)
      relationship_name = "#{name}_dated_relationships".to_sym
      has_many relationship_name, -> { where(key: name) }, class_name: 'DatedRelationship::HasOne', as: :owner

      define_method("#{name}_on") do |date|
        send(relationship_name).feature_on(date)
      end
    end
  end
end
