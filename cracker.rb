require_relative 'helper'
require_relative 'decryptor'

class Cracker

	include Helper

	def initialize(message,date)
		@message = message
		@date = date
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

		@known_string = '..end..'
		@rotation_array = []
	end

	def run
		#puts "char_set_length = " + @char_set.length.to_s
		#we know the known string is at the end of the message
		#so let's compute what rotation we get at when we arrive at the first '.' in '..end..'

		#determine how many digits of the secret code make up '..end..'
		known_string_digits = @known_string.length * @num_digits
		#puts "known_string_digits = #{known_string_digits}"

		#subtract this from the length of the message
		message_without_known_string_digits = @message.length - known_string_digits
		#puts "message_without_known_string_digits = #{message_without_known_string_digits}"
		
		#compute the rotation offset when we arrive at the first '.' in '..end..'
		rotation_offset = (message_without_known_string_digits/@num_digits) % 4
		#puts "rotation_offset = #{rotation_offset}"

		#obtain the original position for the characters that make up '..end..' in our character set
		dot_position = @char_set.index('.').to_i
		#puts "dot_position = #{dot_position}"
		e_position = @char_set.index('e').to_i
		#puts "e_position = #{e_position}"
		n_position = @char_set.index('n').to_i
		#puts "n_position = #{n_position}"
		d_position = @char_set.index('d').to_i
		#puts "d_position = #{d_position}"

		#obtain the encrypted digits for each of the first 4 characters of '..end..'
		encrypted_codes = []
		@message.scan(/.{1,#{@num_digits}}/m).each_with_index do |segment, index|
			encrypted_codes << segment
		end
		encrypted_dot_1 = encrypted_codes[-7]
		#puts "encrypted_dot_1 = #{encrypted_dot_1}"
		encrypted_dot_2 =encrypted_codes[-6]
		#puts "encrypted_dot_2 = #{encrypted_dot_2}"
		encrypted_e = encrypted_codes[-5]
		#puts "encrypted_e = #{encrypted_e}"
		encrypted_n = encrypted_codes[-4]
		#puts "encrypted_n = #{encrypted_n}"
		encrypted_d = encrypted_codes[-3]
		#puts "encrypted_d = #{encrypted_d}"
		encrypted_dot_3 = encrypted_codes[-2]
		#puts "encrypted_dot_3 = #{encrypted_dot_3}"
		encrypted_dot_4 =encrypted_codes[-1]
		#puts "encrypted_dot_4 = #{encrypted_dot_4}"


		#the distance between our offset and original position must be the rotation:
		#
		#as we can deduce from our decryption algorithm:
		#original_position = (current_position - current_offset.to_i - current_rotation.to_i) % @char_set.length
		#current_rotation = (current_position - current_offset - original_position) % @char_set.length

		#now that we know what rotation we are working with, subtract the correct offset from the original position of each character in '..end..' tat corresponds to the position in the rotation
		#process .
		@rotation_array[(rotation_offset) % 4] = (encrypted_dot_1.to_i - @offset_array[(rotation_offset) % 4].to_i - dot_position) % @char_set.length
		#puts "@offset_array[(rotation_offset) % 4].to_i = " + @offset_array[(rotation_offset) % 4].to_s
		#process .
		@rotation_array[(rotation_offset+1) % 4] = (encrypted_dot_2.to_i - @offset_array[(rotation_offset+1) % 4].to_i - dot_position) % @char_set.length
		#puts "@offset_array[(rotation_offset+1) % 4].to_i = " + @offset_array[(rotation_offset+1) % 4].to_s
		#process e
		@rotation_array[(rotation_offset+2) % 4] = (encrypted_e.to_i - @offset_array[(rotation_offset+2) % 4].to_i - e_position) % @char_set.length
		#puts "@offset_array[(rotation_offset+2) % 4].to_i = " + @offset_array[(rotation_offset+2) % 4].to_s
		#process n
		@rotation_array[(rotation_offset+3) % 4] = (encrypted_n.to_i - @offset_array[(rotation_offset+3) % 4].to_i - n_position) % @char_set.length
		#puts "@offset_array[(rotation_offset+3) % 4].to_i = " + @offset_array[(rotation_offset+3) % 4].to_s
		#now we should have the rotation_offsets A, B, C and D in @rotation_array
		#puts @rotation_array.inspect

		crack(@rotation_array)
	end

	#generate all the possible iterations of rotation values
	def generate_increments(rotation_value,increment)
		#puts "processing rotation value: #{rotation_value}"
		increments_array = []


		i=1
		loop do
			increments_array << (rotation_value - (increment*i)) % @num_digits
			#puts 'rotation_value - (increment*i)=' + (rotation_value - (increment*i)).to_s
			if (rotation_value - (increment*i)) < 0
				break
			end
			i += 1
		end
		
		increments_array << rotation_value
		
		i = 1
		loop do
			if rotation_value + (increment*i) >= (10 ** @num_digits)
				break
			end
			increments_array << rotation_value + (increment*i)
			i += 1 
		end

		increments_array
	end

	def crack(rotation_array)
		a_rot_val = b_rot_val = c_rot_val = d_rot_val = ''

		increment = @char_set.length
		a_rot = generate_increments(rotation_array[0], increment).map { |val| "%02d" % val.to_s }
		b_rot = generate_increments(rotation_array[1], increment).map { |val| "%02d" % val.to_s }
		c_rot = generate_increments(rotation_array[2], increment).map { |val| "%02d" % val.to_s }
		d_rot = generate_increments(rotation_array[3], increment).map { |val| "%02d" % val.to_s }
		
		a_rot.each do |a_value|		
			b_rot.each do |b_value|
				c_rot.each do |c_value|
					d_rot.each do |d_value|
						if (a_value[1] == b_value[0]) && (b_value[1] == c_value[0]) && (c_value[1] == d_value[0])
							a_rot_val = a_value
							b_rot_val = b_value
							c_rot_val = c_value
							d_rot_val = d_value
						end
					end
				end
			end
		end
=begin
		puts a_rot.inspect
		puts b_rot.inspect
		puts c_rot.inspect
		puts d_rot.inspect

		puts "a_rot_val.inspect = " + a_rot_val.inspect
		puts "b_rot_val.inspect = " + b_rot_val.inspect
		puts "c_rot_val.inspect = " + c_rot_val.inspect
		puts "d_rot_val.inspect = " + d_rot_val.inspect
=end

		if a_rot_val[0].nil? || a_rot_val[1].nil? || b_rot_val[1].nil? || c_rot_val[1].nil? || d_rot_val[1].nil?
			raise ArgumentError, "encrypted message: '#{@message}' seems to be missing ..end.."
		end

		key = a_rot_val[0] + a_rot_val[1] + b_rot_val[1] + c_rot_val[1] + d_rot_val[1]

#		puts key
		decryptor = Decryptor.new(@message,key,@date)
		decryptor.run


	end
end