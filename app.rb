# encoding: UTF-8

require 'sinatra'
require 'sass'
require 'haml'
require 'mongoid'


# MongoDB config
Mongoid.load! './mongoid.yml'

helpers do
  def sass(template, *args)
    template = "#{settings.sass_dir}/#{template}".to_sym if template.is_a? Symbol
    super(template, *args)
  end
end

configure do
  set :sass_dir, File.join('..', 'public', 'assets', 'stylesheets')
end

get '/assets/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  sass params[:name].to_sym
end


get '/' do
  haml :index, :locals => {:title => "Kon’nichi wa, Ruby"}
end

get '/pokedex' do
  pokemons = Pokemon.all.to_a
  haml :'pokedex/list', :locals => {:title => 'Pokedex', :pokemons => pokemons}
end

get '/pokedex/:id' do
  pokemon_id = params[:id]
  begin
    pokemon = Pokemon.find(pokemon_id)
  rescue
    return 404
  end
  haml :'pokedex/show', :locals => {:title => pokemon.name, :pokemon => pokemon}
end

class Pokemon
  include Mongoid::Document
  field :name,      type: String
  field :type,      type: Array
  field :abilities, type: Array
  field :img,       type: String
end