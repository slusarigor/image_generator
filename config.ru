require 'rubygems'
require 'bundler'
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

Bundler.require

require './app'
run App