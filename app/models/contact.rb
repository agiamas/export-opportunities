class Contact < ApplicationRecord
  validates :name, :email, presence: true
  validates :email, email: { allow_blank: true }

  def email=(value)
    value = value.strip.downcase if value
    super(value)
  end
end
