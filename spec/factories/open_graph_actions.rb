# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :open_graph_action, class: 'OpenGraph::Action' do
    association :member
    action_id "234523462346"
    type 'OpenGraph::Like'
    graph_object {FactoryGirl.create :project}
  end
end
