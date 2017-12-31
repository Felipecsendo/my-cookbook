class RecipeTypesController < ApplicationController
  
  def show
    @recipe_type = RecipeType.find(params[:id])
    @recipes = Recipe.where(cuisine_id: params[:id])
  end
end