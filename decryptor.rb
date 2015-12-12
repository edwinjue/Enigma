require_relative 'helper'
class Decryptor
	
	include Helper

	def initialize(message, key, date)
		@message = message
		#@key = key
		@rotation_array = process_rotation(key)
		#puts "rotation_array = " + @rotation_array.inspect
		#@date = date
		@offset_array = process_offset(date)
		#puts "offset = " + @offset_array.inspect
		@char_set = Constants::CHARSET.split(//)

		#to determine the number of digits we are working with for each character
		#for example: when length of charset reaches 100, we need to make sure '5' gets padded like '005'
		@num_digits =Constants::CHARSET.split(//).length.to_s.length
		
		#check if the encrypted message is valid
		if !is_encrypted_message_valid?(@message,@num_digits)
			raise ArgumentError, "encrypted message: '#{message}' is invalid given the length of the character set"
		end

	end

	def run
		decryptext = ''

		#process entire message by breaking up the message by @num_digits segments (see @num_digits comment in initialize)
		@message.scan(/.{1,#{@num_digits}}/m).each_with_index do |segment, index|
			
			current_position = segment.to_i

			#get current offset
			current_offset = @offset_array[index % @offset_array.length]
			#puts "current_offset = " + current_offset.to_s

			#get current rotation
			current_rotation = @rotation_array[index % @rotation_array.length]
			#puts "current_rotation = " + current_rotation.to_s
			
			original_position = (current_position - current_offset.to_i - current_rotation.to_i) % @char_set.length
			#puts "original_position = #{original_position}"

			decryptext << @char_set[original_position]
		end

		decryptext
	end
end