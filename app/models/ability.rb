class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new

    case user.role
    when "admin"
      can :manage, Company
      can :manage, User
      can :manage, Job
      can :manage, Candidate
    else
      can :read, Company
      can :read, Job
      can :read, Candidate
      can :manage, User, id: user.id
      can :read, User
      can :follow, User
      can :unfollow, User
    end
    user.employer_groups.each do |group|
      get_permission_of_group_for_authentication group
    end
  end

  private

  def get_permission_of_group_for_authentication education_group
    education_group.permissions.each do |permission|
      authenticate permission
    end
  end

  def authenticate permission
    permission.optional.each do |action, accessable|
      if accessable
        can action, permission.entry.constantize
      else
        cannot action, permission.entry.constantize
      end
    end
  end
end
