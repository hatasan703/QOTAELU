class Ability
    include CanCan::Ability

    def initialize(user)
      if user && user.admin?
        can :access, :rails_admin
        can :manage, :all
        can :create, :articles
      end
    end
    
  end


        #   can :identification, :users
        #   can :bank, :users
        #   can :point, :users
