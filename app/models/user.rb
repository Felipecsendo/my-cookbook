class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :favorites
  has_many :recipes
  has_many :favorite_recipes, through: :favorites, source: :recipe
  
  def favorited?(recipe)
   favorite_recipes.include?(recipe)
  end
  
end
