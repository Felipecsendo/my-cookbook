require 'rails_helper'

feature 'Visitor register recipe' do
  scenario 'successfully' do
    
    #cria os dados necessários
    user = create(:user)
    login_as(user, :scope => :user)
    
    Cuisine.create(name: 'Arabe')
    RecipeType.create(name: 'Entrada')
    RecipeType.create(name: 'Prato Principal')
    RecipeType.create(name: 'Sobremesa')
    # simula a ação do usuário
    visit root_path
    click_on 'Enviar uma receita'


    fill_in 'Título', with: 'Tabule'
    select 'Arabe', from: 'Cozinha'
    select 'Entrada', from: 'Tipo da Receita'
    fill_in 'Dificuldade', with: 'Fácil'
    fill_in 'Tempo de Preparo', with: '45'
    fill_in 'Ingredientes', with: 'Trigo para quibe, cebola, tomate picado, azeite, salsinha'
    fill_in 'Como Preparar', with: 'Misturar tudo e servir. Adicione limão a gosto.'
    attach_file('Foto da Receita', "#{Rails.root}/app/assets/images/recipe-cover.jpg")
    click_on 'Enviar'


    expect(page).to have_css('h1', text: 'Tabule')
    expect(page).to have_css('h3', text: 'Detalhes')
    expect(page).to have_css('p', text: 'Entrada')
    expect(page).to have_css('p', text: 'Arabe')
    expect(page).to have_css('p', text: 'Fácil')
    expect(page).to have_css('p', text: "45 minutos")
    expect(page).to have_css('h3', text: 'Ingredientes')
    expect(page).to have_css('p', text: 'Trigo para quibe, cebola, tomate picado, azeite, salsinha')
    expect(page).to have_css('h3', text: 'Como Preparar')
    expect(page).to have_css('p', text:  'Misturar tudo e servir. Adicione limão a gosto.')
    expect(page).to have_css("img[src*='recipe-cover.jpg']")
  end

  scenario 'and must fill in all fields' do
    #cria os dados necessários, nesse caso não vamos criar dados no banco
    user = create(:user)
    login_as(user, :scope => :user)
    Cuisine.create(name: 'Arabe')
    # simula a ação do usuário
    visit root_path
    click_on 'Enviar uma receita'

    fill_in 'Título', with: ''
    fill_in 'Dificuldade', with: ''
    fill_in 'Tempo de Preparo', with: ''
    fill_in 'Ingredientes', with: ''
    fill_in 'Como Preparar', with: ''
    click_on 'Enviar'


    expect(page).to have_content('Você deve informar todos os dados da receita')
  end
  
  scenario 'and dont upload the cover' do
    recipe = create(:recipe)
    
    visit recipe_path(recipe)
    
    expect(page).to have_css("img[src*='sem-foto.gif']")
  end
  
  scenario 'and set up as featured' do
    user = create(:user)
    cuisine = create(:cuisine)
    recipe_type = create(:recipe_type)
    
    login_as(user, :scope => :user)

    visit root_path
    click_on 'Enviar uma receita'


    fill_in 'Título', with: 'Tabule'
    select cuisine.name, from: 'Cozinha'
    select recipe_type.name, from: 'Tipo da Receita'
    fill_in 'Dificuldade', with: 'Fácil'
    fill_in 'Tempo de Preparo', with: '45'
    fill_in 'Ingredientes', with: 'Trigo para quibe, cebola, tomate picado, azeite, salsinha'
    fill_in 'Como Preparar', with: 'Misturar tudo e servir. Adicione limão a gosto.'
    attach_file('Foto da Receita', "#{Rails.root}/app/assets/images/recipe-cover.jpg")
    check('Destaque')
    click_on 'Enviar'
    
    expect(page).to have_css("img[src*='star']")
    
    
  end
end
