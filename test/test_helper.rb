require 'bundler/setup'
require 'pry'

require 'simplecov'
SimpleCov.start 'rails'

#minitest HAVE TO been required after simplecov to get coverage work
require 'minitest/autorun'
