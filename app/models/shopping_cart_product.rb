class ShoppingCartProduct < ApplicationRecord
  belongs_to :shopping_cart
  belongs_to :product

  after_create :update_total!
  after_destroy :update_total!

  private

  def update_total!
    self.shopping_cart.update_total!
  end
end
