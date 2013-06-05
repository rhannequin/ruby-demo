# encoding: UTF-8

require 'sinatra'
require 'sass'
require 'haml'
require 'json'
require 'mongoid'


# MongoDB config
Mongoid.load! './mongoid.yml'

# SASS Helpers
helpers do
  def sass(template, *args)
    template = "#{settings.sass_dir}/#{template}".to_sym if template.is_a? Symbol
    super(template, *args)
  end
end

# Sinatra conf
configure do
  set :sass_dir, File.join('..', 'public', 'assets', 'stylesheets')
end

# Handle SASS stylesheets
get '/assets/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass params[:name].to_sym
end


# Root page
get '/' do
  haml :index, :locals => {:title => "Kon’nichi wa, Ruby"}
end

# List of Pokemons
get '/pokedex' do
  pokemons = Pokemon.all.to_a
  haml :'pokedex/list', :locals => {:title => 'Pokedex', :pokemons => pokemons}
end

# List of Pokemons
post '/pokedex' do
  pokemon = Pokemon.new(params[:pokemon])
  pokemon.save
  content_type :json
  return { :status => 'OK', :data => pokemon }.to_json
end

# Add a Pokemon
get '/pokedex/new' do
  haml :'pokedex/new', :locals => {:title => "Add a Pokemon"}
end

# Show a Pokemon
get '/pokedex/:id' do
  pokemon_id = params[:id]
  begin
    pokemon = Pokemon.find(pokemon_id)
  rescue
    return 404
  end
  haml :'pokedex/show', :locals => {:title => pokemon.name, :pokemon => pokemon}
end

# Update a Pokemon
put '/pokedex/:id' do
  pokemon_id = params[:id]
  begin
    content_type :json
    pokemon = Pokemon.find(pokemon_id)
    pokemon.update_attributes params[:pokemon]
    return { :status => 'OK', :pokemon => pokemon }.to_json
  rescue
    return 404
  end
end

# Remove a Pokemon
delete '/pokedex/:id' do
  pokemon_id = params[:id]
  begin
    content_type :json
    pokemon = Pokemon.find(pokemon_id)
    pokemon.delete
    return { :status => 'OK' }.to_json
  rescue
    return 404
  end
end

# Edit a Pokemon
get '/pokedex/:id/edit' do
  pokemon_id = params[:id]
  begin
    pokemon = Pokemon.find(pokemon_id)
  rescue
    return 404
  end
  haml :'pokedex/edit', :locals => {:title => "Edit #{pokemon.name}", :pokemon => pokemon}
end


# Models

class Pokemon
  include Mongoid::Document
  field :name,      type: String
  field :types,     type: Array
  field :abilities, type: Array
  field :img,       type: String
end