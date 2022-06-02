# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  title      :string
#  code       :string
#  price      :integer          default(0)
#  stock      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord

  before_save :validate_product
  after_save :send_notification
  after_save :push_notification, if: :discount?

  #  se puede usar para presence true   validates_presence_of :attribute, message: 'Mensaje'
  #  validates_uniqueness_of :email, message: 'Mensaje'
  # validates_length_of :members, :minimum => 1
  # validates_length_of :code, :minimum => 3
  validates :price, length: { in: 3..10, message: 'Precio fuera de rango' }, if: :has_price?
  validate :code_validate # es validacion propia
  validates_with ProductValidator #aqui le dices que ejecute el moetod validatedel concern

  def total
    self.price / 100
  end

  def discount?
    self.total < 5
  end

  def has_price?
    !self.price.nil? && self.price > 0
  end

  private

  def code_validate
    if self.code.nil? || self.code.length < 3
      self.errors.add(:code, 'El codigo debe tener minimo 3 caracteres')
    # .errors.add agrega un nuevo mensaje de error
    end
  end

  def validate_product
    puts "\n\n>>> Un nuevo producto sera agregado"
  end

  def send_notification
    puts "\n\n>>> Un nuevo producto fue agregado: #{self.title} - #{self.total} USD"
  end

  def push_notification
    puts "\n\n>> Un nuevo producto ya se encuentra disponible"
  end
end


# En consola:
# Product.where(title: 'xxd').or(Product.where(title: 'xxx')
# Product.where('price >= 1500')
# Product.where('price >= ?', 1500)
# Product.where('price >= ? and code = ?', 1500, '0011') o Product.where('price >= ?', 1500).where(code: '0011')
# Product.where('price >= 1500').each do |p|
#   puts p.title
# end
# Product.find(2,3,4) o Product.find([2,3,4])
# find_by es lo mismo que where solo que where arroja todos los resultados pero find_by solo el primero
