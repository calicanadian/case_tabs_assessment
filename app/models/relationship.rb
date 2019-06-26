class Relationship < ApplicationRecord
  belongs_to :component
  belongs_to :dependent, class_name: "Component", dependent: :destroy
end
