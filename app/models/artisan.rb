class Artisan < ApplicationRecord
  belongs_to :admin

  has_many :products, dependent: :destroy

  has_secure_password

  validates :store_name, presence: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }

  after_update :update_product_visibility, if: -> { saved_change_to_active? }

  # Public Methods
  def active_for_authentication?
    active
  end

  def inactive_message
    'Your account has been deactivated. Please contact your administrator.'
  end

  private

  def update_product_visibility
    products.find_each do |product|
      product.update(visible: active)
    end
  end
end
