module User::Hierarchy
  extend ActiveSupport::Concern

  # only for Users right now but could conceivably extend to OAuth objects
  
  included do  
    scope :admins, -> { where(id: UserPrivilege.distinct.pluck(:user_id)) }
  end
  
  # alias method
  def assign_privilege(privilege, scope = nil)
    UserPrivilege.assign(self, privilege, scope)
  end

  # alias method
  def has_privilege?(privilege, scope = nil)
    UserPrivilege.has_privilege?(self, privilege, scope)
  end

  def is_admin?
    !self.privileges.empty?
  end

  def is_superadmin?
    ((self.email == 'yutian.mei@gmail.com') || (self.email == 'test@diem25.org')) and [1, 2, 8, 2945].include?(self.id)
  end
  
  def privileges
    @privileges ||= UserPrivilege.where(user_id: self.id).pluck(:privilege, :scope)
  end
  
end
