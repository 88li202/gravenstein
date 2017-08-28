class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Application name
  NAME = 'Gravenstein'.freeze

end
