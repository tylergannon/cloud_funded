class Ability < ActiveRecord::Base
  include CanCan::Ability

  def initialize(member)
    
    if member
      if member.admin
        can :manage, :all
        can :rule, :the_world
        can :see, :facebook_actions
      end
      
      can :read, Project, owner_id: member.id
      can :manage, OpenGraph::Action, member_id: member.id
      can :create, Project
      can :manage, Projects::Perk, project: {owner_id: member.id}
      can :create, Feedback
      can :edit, Project, owner_id: member.id
      can :edit, Project, id: member.administered_project_ids
      can :create, Pledge
      can :edit, Pledge, investor_id: member.id
      can :manage, Pledge, investor_id: member.id
      can :manage, Pledge, project: {owner_id: member.id}
      can :destroy, Comment, member_id: member.id
      can :edit, Member, id: member.id        
      can :manage, Article, project: {owner_id: member.id}
      can [:read, :create, :edit, :destroy], Projects::Role, project: {owner_id: member.id}
      can :manage, Projects::Role, member_id: member.id
      if member.first_name == 'Facebook'
        can :see, :facebook_actions
      end
    end
    
    #everyone can see projects
    can :read, Pledge
    can :read, Project, workflow_state: 'live', visible: true
    can :read, Projects::Perk do |perk|
      perk.project.published?
    end
    
    can :read, Member
    can :read, Article, workflow_state: 'published'
    
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
