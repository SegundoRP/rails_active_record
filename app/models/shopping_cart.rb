# == Schema Information
#
# Table name: shopping_carts
#
#  id         :bigint           not null, primary key
#  total      :integer          default(0)
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ShoppingCart < ApplicationRecord
  belongs_to :user
  has_many :shopping_cart_products
  has_many :products, through: :shopping_cart_products

  def price
    self.total / 100
  end

  def update_total!
    # al usar ! en metodos es decirle al usuario que al usar el metodo puede ocurrir algun error
    self.update(total: self.get_total)
  end

  # def get_total
  #   total = 0

  #   # como dentro del each se llamada a tabla propduct entonces lo usamos con el includes para hacer emnos cionsultas, solucionar el n+1 queries
  #   self.shopping_cart_products.includes(:product).each do |scp|
  #     total += scp.product.price
  #   end
  #   # otra forma de lo de arriba es
  #   # self.products.each do |product|
  #   # total += product.price
  #   # end
  #   # end
  #   total
  # end

  def get_total
    ShoppingCart.joins(:shopping_cart_products)
    .joins(:products)
    .where(shopping_carts: { id: 2 })
    .group(:shopping_cart_products)
    .select('SUM(products.price) AS total')[0].total
    # el join junta las tablas, aqui junto 3 tablas
  end


end
