require 'rubygems'
require 'open-uri'
require 'digest/md5'
require 'redis'
require 'nokogiri'
require './notifiers/_notifiers.rb'

if ENV['RACK_ENV'] != 'production'
	require 'dotenv/load'
end

desc "check url defined in ENV['CHECKED_URL']"
task :check do
	if ENV['CHECKED_URL'].nil?
		puts "CHECKED_URL must be defined"
		next
	end

	response = open(ENV['CHECKED_URL']).read
	
	doc = Nokogiri.HTML(response)

	if ENV['ELEMENTS_BLACK_LIST']
		ENV['ELEMENTS_BLACK_LIST'].split(',').each do |e|
			doc.css(e).remove
		end
	end

	current_hash = Digest::MD5.hexdigest(doc)

	redis = Redis.new()

	known_hash = redis.get(ENV['CHECKED_URL'])

	if current_hash != known_hash
		puts "changes!"
		puts current_hash
		puts known_hash.nil? ? "first check" : known_hash

		URL_Notifier.notify

		redis.set(ENV['CHECKED_URL'], current_hash)
	end
end

desc "clean redis cache"
task :clean do
	redis = Redis.new()
	redis.set(ENV['CHECKED_URL'], nil)
end