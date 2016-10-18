require 'rails_helper'

describe Consultant, type: :model do
  let(:consultant) { Consultant.create!(first_name: 'John', last_name: 'Smith') }

  describe 'dated has many' do
    let(:effect_from) { Date.new(2016, 1, 1) }
    let(:effect_to) { Date.new(2016, 2, 28) }

    it 'can build a project' do
      project = consultant.build_project(name: 'Project A', client: 'IBM', effect_from: effect_from, effect_to: effect_to)
      expect(project.name).to eq('Project A')
      expect(project.client).to eq('IBM')
      expect(project.dated_relationship).to be_a(DatedRelationship::HasMany)
      expect(project.dated_relationship.owner).to eq(consultant)
      expect(project.dated_relationship.key).to eq('projects')
      expect(project.dated_relationship.effect_from).to eq(today)
      expect(project.dated_relationship.effect_to).to eq(tomorrow)

      expect(project).to_not be_persisted
      expect(project.dated_relationship).to_not be_persisted
      project.save!
      expect(project).to be_persisted
      expect(project.dated_relationship).to be_persisted
    end

    describe 'querying' do
      let(:project_a) { consultant.build_project(name: 'Project A', client: 'IBM', effect_from: '2016-01-01', effect_to: '2016-02-28') }
      let(:project_b) { consultant.build_project(name: 'Project B', client: 'SAP', effect_from: '2016-02-01', effect_to: nil) }
      let(:project_c) { consultant.build_project(name: 'Project C', client: 'Oracle', effect_from: nil, effect_to: '2016-02-15') }

      before { [project_a, project_b, project_c].each(&:save!) }

      describe '#projects_on' do
        it 'returns the expected projects' do
          expect(consultant.projects_on(Date.new(2000, 1, 1))).to match_array [project_c]
          expect(consultant.projects_on(Date.new(2015, 12, 31))).to match_array [project_c]
          expect(consultant.projects_on(Date.new(2016, 1, 1))).to match_array [project_a, project_c]
          expect(consultant.projects_on(Date.new(2016, 1, 31))).to match_array [project_a, project_c]
          expect(consultant.projects_on(Date.new(2016, 2, 1))).to match_array [project_a, project_b, project_c]
          expect(consultant.projects_on(Date.new(2016, 2, 15))).to match_array [project_a, project_b, project_c]
          expect(consultant.projects_on(Date.new(2016, 2, 16))).to match_array [project_a, project_b]
          expect(consultant.projects_on(Date.new(2016, 2, 28))).to match_array [project_a, project_b]
          expect(consultant.projects_on(Date.new(2016, 3, 1))).to match_array [project_b]
          expect(consultant.projects_on(Date.new(2020, 1, 1))).to match_array [project_b]
        end
      end

      describe '#projects_overlapping' do
        it 'returns the expected projects' do
          expect(consultant.projects_overlapping(Date.new(2015, 1, 1), Date.new(2015, 12, 31))).to match_array [project_c]
          expect(consultant.projects_overlapping(Date.new(2015, 12, 31), Date.new(2016, 1, 31))).to match_array [project_a, project_c]
        end
      end
    end
  end
end
