class ProductValidator < ActiveModel::Validator

  # Por convencion se llama siempre validate y el record es el objeto que queremos validar
  def validate(record)
    self.validate_stock(record)
  end

  def validate_stock(record)
    if record.stock < 0
      record.errors.add(:stock, 'Stock no puede ser negativo')
    end
  end
end

# Si usamos modelos con herencia o atribuytos duplicados es buena idea hacer validaciones con concerns, con clases, para no repetir codigo
