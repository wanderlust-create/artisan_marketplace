module SessionPermissions
  def verify_user_permissions(user)
    if user.respond_to?(:active_for_authentication?) && !user.active_for_authentication?
      { status: :inactive, message: user.inactive_message }
    else
      { status: :active }
    end
  end
end
