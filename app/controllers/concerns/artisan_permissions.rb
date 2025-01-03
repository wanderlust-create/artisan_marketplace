module ArtisanPermissions
  extend ActiveSupport::Concern

  included do
    helper_method :can_edit_artisan?, :can_delete_artisan?, :can_view_artisan?
  end

  def can_edit_artisan?
    if current_user.is_a?(Admin)
      current_user.super_admin? || current_user.id == @artisan.admin_id
    elsif current_user.is_a?(Artisan)
      current_user == @artisan
    else
      false
    end
  end

  def can_delete_artisan?
    if current_user.is_a?(Admin)
      current_user.super_admin? || current_user.id == @artisan.admin_id
    elsif current_user.is_a?(Artisan)
      false
    else
      false
    end
  end

  def can_view_artisan?
    current_user.is_a?(Admin) || current_user == @artisan
  end
end
