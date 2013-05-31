# encoding: UTF-8

require 'sinatra'
require 'sass'
require 'haml'



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
  logger.info 'lol'
  content_type 'text/css', :charset => 'utf-8'
  sass params[:name].to_sym
end



get '/' do
  haml :index, :locals => {:title => "Kon’nichi wa, Ruby"}
end

get '/pokedex' do
  haml :'pokedex/list', :locals => {:title => 'Pokedex'}
end