class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end


# En consola
# .new_record? esto es si se ha creado nuevo registro pero no se grabo
#  .persisted? esto es si se grabo con save el nuevo registro
