class Ability
  include CanCan::Ability

  def initialize(member)
    if member
      if member.admin
        can :manage, :all
      else
        can :read, Project, owner_id: member.id
      
        can :create, Project
        can :create, Feedback
        can :edit, Project, owner_id: member.id
        can :create, Pledge
        can :edit, Pledge, investor_id: member.id
        can :manage, Pledge, investor_id: member.id
        can :manage, Pledge, project: {owner_id: member.id}
        can :destroy, Comment, member_id: member.id
        can :edit, Member, id: member.id        
      end
    end
    
    #everyone can see projects
    can :read, Pledge
    can :read, Project, active: true
    can :read, Member
    can :manage, Article do |article|
      article.project &&
        article.project.owner.id == member.id
    end
    can :read, Article do |article|
      article.published
    end
    
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
