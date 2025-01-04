module ArtisanPermissions
  extend ActiveSupport::Concern

  included do
    helper_method :can_manage_artisan?, :can_view_artisan?
  end

  def can_manage_artisan?(action)
    case action
    when :edit
      can_edit_artisan?
    when :create
      can_create_artisan?
    when :delete
      can_delete_artisan?
    else
      false
    end
  end

  private

  def can_edit_artisan?
    return false unless @artisan

    if current_user.is_a?(Admin)
      current_user.super_admin? || current_user.id == @artisan.admin_id
    elsif current_user.is_a?(Artisan)
      current_user == @artisan
    else
      false
    end
  end

  def can_create_artisan?
    current_user.is_a?(Admin) && (current_user.super_admin? || current_user == @admin)
  end

  def can_delete_artisan?
    return false unless @artisan

    current_user.is_a?(Admin) && (current_user.super_admin? || current_user.id == @artisan.admin_id)
  end

  def can_view_artisan?
    current_user.is_a?(Admin) || current_user == @artisan
  end
end
