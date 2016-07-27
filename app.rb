require 'sinatra'
require 'pg'
require 'sinatra/reloader'
require 'active_record'
require "net/http"

require_relative 'db/connection'
require_relative 'models/pokemon'
require_relative 'models/trainer'

get '/' do
	"hello world"	
end

get '/pokemons' do
	@pokemons = Pokemon.all
	erb :"pokemon/index"	
end

get '/pokemons/by_name' do
	@pokemons = Pokemon.all.sort_by { |i| i["name"] }
	erb :"pokemon/index"	
end

get '/pokemons/by_cp' do
	@pokemons = (Pokemon.all.sort_by { |i| i["cp"].to_i }).reverse
	erb :"pokemon/index"
end

get '/pokemon/new' do
	erb :"pokemon/new"
end

get '/pokemon/:id' do
	@pokemon = Pokemon.find(params[:id])
	erb :"pokemon/show"
end

get '/pokemon/:id/edit' do
	@pokemon = Pokemon.find(params[:id]);
	erb :"pokemon/edit"
end

post '/pokemon' do
	params[:pokemon]["img_url"] = "https://img.pokemondb.net/sprites/black-white/anim/normal/#{params[:pokemon]["name"].downcase}.gif"
	if params[:pokemon]["name"] == ""
		params[:pokemon]["name"] = "Unknown"
	end
	if params[:pokemon]["cp"] == ""
		params[:pokemon]["cp"] = "0"
	end
	if params[:pokemon]["poke_type"] == ""
		params[:pokemon]["poke_type"] = "Unknown"
	end
	new_pokemon = Pokemon.create(params[:pokemon])
	redirect "/pokemon/#{ new_pokemon.id }"
end

put '/pokemon/:id' do
	pokemon = Pokemon.find(params[:id])
	pokemon.update(params[:pokemon])
	redirect "/pokemon/#{ pokemon.id }"
end

delete '/pokemon/:id' do
	pokemon = Pokemon.find(params[:id])
	pokemon.destroy
	redirect "/pokemons"
end





