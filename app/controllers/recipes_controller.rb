class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new edit destroy update mine]
  before_action :set_recipe, only: %i[show edit update
                                      favorite destroy_favorite share]
  before_action :options_for_select,
                only: %i[show new create edit update
                         search my_favorites list mine]

  def show
    id = params[:id]
    @favorite = Favorite.new
    @recipe = Recipe.find id
    @cuisine = Cuisine.find(@recipe.cuisine_id).name
  end

  def new
    @recipe = Recipe.new
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      @cuisine = Cuisine.find(@recipe.cuisine_id).name
      redirect_to @recipe, notice: 'Receita Cadastrada com sucesso!'
    else
      flash.now[:alert] = 'Você deve informar todos os dados da receita'
      render 'new'

    end
  end

  def edit
    @recipe = Recipe.find params[:id]
    if @recipe.user_owner?(current_user)
      return
    else
      redirect_to root_path, notice: 'Você não tem permissão para isso!'
    end
  end

  def update
    @recipe = Recipe.find params[:id]
    if @recipe.user_owner?(current_user)
      if @recipe.update(recipe_params)
        redirect_to @recipe, notice: 'Receita atualizada com sucesso!'
      else
        flash.now[:alert] = 'Você deve informar todos os dados da receita'
        render 'edit'
      end
    else
      redirect_to root_path, notice: 'Você não tem permissão para isso!'
    end
  end

  def destroy
    @recipe = Recipe.find params[:id]
    if @recipe.destroy
      redirect_to root_path
    else
      flash.now[:notice] = 'Esta receita não pode ser excluída'
      render 'show'
    end
  end

  def search
    @query = params[:query]
    @results = Recipe.where('title LIKE ? OR ingredients LIKE ?',
                            @query, @query)
  end

  def my_favorites
    user_favorites
  end

  def list
    options_for_select
  end

  def mine
    user_recipes
  end

  def favorite
    user = params[:user]
    recipe = params[:recipe]
    @favorite = User.find(user).favorites.new(recipe_id: recipe)
    return unless @favorite.save
    redirect_to recipe_path(recipe), notice: 'Receita adicionada aos favoritos!'
  end

  def destroy_favorite
    recipe = params[:recipe]
    @favorite = Favorite.find_by user_id: current_user, recipe_id: params[:id]
    if @favorite.destroy
      redirect_to recipe_path(recipe),
                  notice: 'Receita removida dos favoritos.'
    else
      redirect_to recipe_path(recipe),
                  notice: 'Receita não pode ser removida dos favoritos'
    end
  end

  def share
    email = params[:email]
    msg = params[:message]

    UserMailer.recommend_email(email, msg,
                               @recipe.id).deliver_now

    flash[:notice] = "Receita enviada para #{email}"
    redirect_to @recipe
  end
end

private

def options_for_select
  @recipe_all = Recipe.all
  @recipe_type_all = RecipeType.all
  @cuisine_all = Cuisine.all
end

def user_favorites
  @favorites = []
  fav = Favorite.where(user: current_user)
  fav.each do |f|
    @favorites << f.recipe
  end
end

def user_recipes
  @my_recipes = Recipe.where(user: current_user)
end

def recipe_params
  params.require(:recipe).permit(:title,
                                 :cuisine_id,
                                 :recipe_type_id,
                                 :difficulty,
                                 :cook_time,
                                 :ingredients,
                                 :method,
                                 :recipe_cover,
                                 :featured)
end

def set_recipe
  @recipe = Recipe.find(params[:id])
end
