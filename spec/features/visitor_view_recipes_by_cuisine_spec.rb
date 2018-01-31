require 'rails_helper'

feature 'Visitor view recipes by cuisine' do
  scenario 'from home page' do
    cuisine = create(:cuisine, name: 'Brasileira')
    recipe_type = create(:recipe_type, name: 'Sobremesa')
    recipe = create(:recipe, title: 'Bolo de cenoura', recipe_type: recipe_type,
                             cuisine: cuisine, difficulty: 'Médio',
                             cook_time: 60,
                             ingredients: 'Farinha, açucar, cenoura',
                             method: 'Cozinhe a cenoura, corte em pedaços
                                      pequenos, misture com o restante dos
                                      ingredientes')

    visit root_path
    click_on cuisine.name

    expect(page).to have_css('h1', text: cuisine.name)
    expect(page).to have_css('h3', text: recipe.title)
    expect(page).to have_css('li', text: recipe.recipe_type.name)
    expect(page).to have_css('li', text: recipe.cuisine.name)
    expect(page).to have_css('li', text: recipe.difficulty)
    expect(page).to have_css('li', text: "#{recipe.cook_time} minutos")
  end

  scenario 'and view only cuisine recipes' do
    cuisine = create(:cuisine, name: 'Brasileira')
    recipe_type = create(:recipe_type, name: 'Sobremesa')
    create(:recipe, title: 'Bolo de cenoura', recipe_type: recipe_type,
                    cuisine: cuisine, difficulty: 'Médio',
                    cook_time: 60,
                    ingredients: 'Farinha, açucar, cenoura',
                    method: 'Cozinhe a cenoura, corte em pedaços
                             pequenos, misture com o restante dos
                             ingredientes')

    italian_cuisine = create(:cuisine, name: 'Italiana')
    main_recipe_type = create(:recipe_type, name: 'Prato Principal')
    italianr = create(:recipe, title: 'Macarrão Carbonara',
                               recipe_type: main_recipe_type,
                               cuisine: italian_cuisine, difficulty: 'Difícil',
                               cook_time: 30, ingredients: 'Massa, ovos, bacon',
                               method: 'Frite o bacon; Cozinhe a massa ate ficar
                                        al dent; Misture os ovos e o bacon a
                                        massa ainda quente;')
    visit root_path
    click_on italian_cuisine.name

    expect(page).to have_css('h3', text: italianr.title)
    expect(page).to have_css('li', text: italianr.recipe_type.name)
    expect(page).to have_css('li', text: italianr.cuisine.name)
    expect(page).to have_css('li', text: italianr.difficulty)
    expect(page).to have_css('li', text: "#{italian_recipe.cook_time} minutos")
  end

  scenario 'and cuisine has no recipe' do
    brazilian_cuisine = create(:cuisine, name: 'Brasileira')
    recipe_type = create(:recipe_type, name: 'Sobremesa')
    recipe = create(:recipe, title: 'Bolo de cenoura', recipe_type: recipe_type,
                             cuisine: brazilian_cuisine, difficulty: 'Médio',
                             cook_time: 60,
                             ingredients: 'Farinha, açucar, cenoura',
                             method: 'Cozinhe a cenoura, corte em pedaços
                                      pequenos, misture com o restante dos
                                      ingredientes')

    italian_cuisine = create(:cuisine, name: 'Italiana')
    visit root_path
    click_on italian_cuisine.name

    expect(page).not_to have_content(recipe.title)
    expect(page).to have_content('Nenhuma receita encontrada para este
                                  tipo de cozinha')
  end
end
