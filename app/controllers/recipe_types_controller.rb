class RecipeTypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  
  def show
    options_for_select
    @recipe_type = RecipeType.find(params[:id])
    @recipes = Recipe.where(cuisine_id: params[:id])
  end
  
  def new
    options_for_select
    @recipe_type = RecipeType.new
  end
  
  def create
    options_for_select
    @recipe_type = RecipeType.create(recipe_type_params)
    if @recipe_type.save
      redirect_to @recipe_type, notice: 'Tipo de Receita cadastrado com sucesso'
    else
      redirect_to new_recipe_type_path, notice: 'Você deve informar o nome do tipo de receita'
    end
  end
end

private
  
  def options_for_select
    @recipe_all = Recipe.all
    @recipe_type_all = RecipeType.all
    @cuisine_all = Cuisine.all
  end
  
  def recipe_type_params
    params.require(:recipe_type).permit(:name)
  end
    