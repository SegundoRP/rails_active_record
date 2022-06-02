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
  before_update :code_notification_changed, if: :code_changed? # esto aplicara si el atributo code fue modificado
  after_update :send_notification_stock, if: :stock_limit?
  #  se puede usar para presence true   validates_presence_of :attribute, message: 'Mensaje'
  #  validates_uniqueness_of :email, message: 'Mensaje'
  # validates_length_of :members, :minimum => 1
  # validates_length_of :code, :minimum => 3
  validates :price, length: { in: 3..10, message: 'Precio fuera de rango' }, if: :has_price?
  validate :code_validate # es validacion propia
  validates_with ProductValidator #aqui le dices que ejecute el moetod validatedel concern

  scope :available, -> (min=1) { where['stock >=?', min] } #lo puedes llamar como Product.available(2), registra un metodo de clase
  scope :order_price_desc, -> { order('price DESC') } # puedes llamar a los dos Product.available(2).order_price_desc
  scope :available_and_order_price_desc, -> { available.order_price_desc } #los dos scopes funcionan en uno

  def total
    self.price / 100
  end

  def discount?
    self.total < 5
  end

  def has_price?
    !self.price.nil? && self.price > 0
  end

  # Cuando hayan consultas mas complejas no es con scope sino con metodo de clase
  def self.top_five_available
    self.available.order_price_desc.limit(5).select(:title, :code)
  end

  private

  def stock_limit?
    self.saved_change_to_stock? && self.stock <= 5
  end

  def code_notification_changed
    puts "\n\n>> el atributo code fue modificado"
  end

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

  def send_notification_stock
    puts "\n\n>> El producto #{self.title} esta escaso"
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
# Product.all.order('price DESC').limit(3) o Product.all.order(price: :desc).limit(3)
# Product.where('price >= 1500').exists? o Product.where('price >= 1500').count > 0
# Product.all.order('price DESC').limit(3).select(:title, :code) siempre agregara el id al resultado, retoirna listado de objetos
# Product.all.order('price DESC').limit(3).pluck(:title) en vez de que pase por todos los atributos solo ira por el qe le indiques y se tardara menos tiempo, retorna listado de valores no objetos
# Product.find_or_create_by(title: 'aaaa')
# Product.where(title: 'camisa').first_or_create encontrara al primero o lo creara de no existir puede usar bloques como lineas arriba a diferencia del find or create
# product = Product.last // product.update(title: 'ss', price: 33) // product.update_attribute(:price, 1260) solo actualiza un atributo y no esta sujeto a las validaciones // // product.update_attributes(price: 1260, title: 'dde') sis e puede mas de 1 atributo
#  product.update_column(:price, 1260) validaciones seran omitidasy callbacks es peligroso  // product.update_columns(price: 1260, title: 'dde') lomismo solo que plural
# product.destroy // .destroy_all
#  product.changed? true o false si fue modificado // product.changes da un hash con los cambios // product.attribute_changed? con esto preguntas si un atrobuto determinado fue modificado // product.attribute_was da el valor anterior // si es persistido el objeto o sea guardado ya se visualizara como que no haya habido cambios
#  product.saved_change_to_attribute(debes poner aqui el atributio)? esto te dira si fue actualiado ese atributo a pesar de haberse grabado o persistido

end
