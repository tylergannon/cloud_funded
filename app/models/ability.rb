class Ability
  include CanCan::Ability

  def initialize(member)
    if member
      if member.admin
        can :manage, :all
      else
        can :read, Project, owner_id: member.id
      
        can :create, Project
        can :edit, Project, owner_id: member.id
        can :create, Pledge
        can :edit, Pledge, investor_id: member.id
        can :destroy, Pledge, investor_id: member.id
      end
    end
    
    #everyone can see projects
    can :read, Pledge
    can :read, Project, active: true
    
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
