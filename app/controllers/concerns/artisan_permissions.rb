module ArtisanPermissions
  extend ActiveSupport::Concern

  included do
    helper_method :can_edit_artisan?, :can_manage_artisan?, :can_view_artisan?
  end

  def can_manage_artisan?(action) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    case action
    when :edit
      if current_user.is_a?(Admin)
        current_user.super_admin? || current_user.id == @artisan.admin_id
      elsif current_user.is_a?(Artisan)
        current_user == @artisan
      else
        false
      end
    when :create, :delete
      current_user.is_a?(Admin) && (current_user.super_admin? || current_user.id == @artisan.admin_id)
    else
      false
    end
  end

  def can_view_artisan?
    current_user.is_a?(Admin) || current_user == @artisan
  end

end
