# == Schema Information
#
# Table name: users
#
#  id         :bigint           not null, primary key
#  username   :string           not null
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  has_many :shopping_carts
  has_one :shopping_cart, -> { where(active: true).order('id DESC') } #esto es porque un usuario solo podra poseer un carrito compras activo a diferencia de arriba que puede tener varios carritos de compras si llamas al modelo.shopping_cart te dara el primer carrito de compras por defecto
  # eso del where hara que aplica sobre la lista de arriba y dara solo el ultimo true
end
