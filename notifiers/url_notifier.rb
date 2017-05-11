require_relative '_notifiers'
require 'open-uri'

class URL_Notifier < Notifier
	def self.notify
		if ENV['NOTIFICATION_URL'].nil?
			puts "NOTIFICATION_URL not set"
			return
		end

		response = open(ENV['NOTIFICATION_URL']).read

		puts "notified:"
		puts response
	end
end