# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.admin?
      # Admin can manage everything
      can :manage, :all
      can :manage, User
    elsif user.viewer?
      # Viewer can only read resources
      can :read, :all
      can :read, ActiveAdmin::Page, name: "Dashboard"

      # Prevent viewers from accessing user management
      cannot :manage, User
      cannot :create, :all
      cannot :update, :all
      cannot :destroy, :all
    else
      # Not logged in - no permissions
      cannot :manage, :all
    end
  end
end
