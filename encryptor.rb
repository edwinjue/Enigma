require_relative 'constants'
require_relative 'helper'

class Encryptor
	
	include Helper

	attr_reader :key, :date

	def initialize(params)
		#p params
		@message = params[:message]
		@key = validate_key(params[:key])
		@date = validate_date(params[:date])
		
		@rotation_array = process_rotation(@key)
		#puts "rotation_array = " + @rotation_array.inspect
		
		@offset_array = process_offset(@date)
		#puts "offset = " + @offset_array.inspect
		@char_set = Constants::CHARSET.split(//)
		
		#to determine the number of digits we are working with for each character
		#for example: when length of charset reaches 100, we need to make sure '5' gets padded like '005'
		@num_digits =Constants::CHARSET.split(//).length.to_s.length
	end

	def run
		encryptext = ''
		#originalpos = ''
		#process entire message, character by character
		@message.split(//).each_with_index do |char, index|
			#get index of char in charset
			
			#get current position of char in our character set
			current_position = @char_set.index(char)
			#originalpos << "%02d" % current_position.to_s

			#puts "current_position = " + current_position.to_s
			#puts "@char_set[current_position]=" + @char_set[current_position].to_s

			#get current offset
			current_offset = @offset_array[index % @offset_array.length]
			#puts "current_offset = " + current_offset.to_s

			#get current rotation
			current_rotation = @rotation_array[index % @rotation_array.length]
			#puts "current_rotation = " + current_rotation.to_s
	
			#perform arithmetic
			segment = (current_position.to_i + current_rotation.to_i + current_offset.to_i) % @char_set.length

			#encryptext << "%0#{@num_digits}d" % segment.to_s
			encryptext << segment.to_s.rjust(@num_digits,'0')
		end
		#puts originalpos
		encryptext
	end

end