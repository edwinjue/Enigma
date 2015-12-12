require_relative 'constants'
require_relative 'helper'
require_relative 'encryptor'
require_relative 'decryptor'
require_relative 'cracker'

class Enigma 

	include Helper
	
	def initialize
		@keygen = Keygen.new
	end
	
	def encrypt(plaintext, key=nil, date=nil)
		#puts "calling encrypt"

		valid_message = validate_message(plaintext)
		
		valid_key = validate_key(key)
		#puts "valid_key = " + valid_key.inspect
		
		valid_date = validate_date(date)
		#puts "valid_date = " + valid_date.inspect

		encryptor = Encryptor.new(valid_message, valid_key, valid_date)		
		encryptor.run
	end

	def decrypt(encryptext, key, date=nil)
		#puts "calling decrypt"

		valid_message = validate_message(encryptext)
		
		valid_key = validate_key(key)
		#puts "valid_key = " + valid_key.inspect
		
		valid_date = validate_date(date)
		#puts "valid_date = " + valid_date.inspect

		decryptor = Decryptor.new(valid_message, valid_key, valid_date)
		decryptor.run
	end

	def crack(encryptext)
		cracker = Cracker.new
	end
end
=begin
e = Enigma.new
my_message = "this is so secret ..end.."
output = e.encrypt(my_message)
puts output
output = e.encrypt(my_message, 12345, '092480')
output = e.encrypt(my_message, 12345, Date.new(2014, 10, 5) )
output = e.encrypt(my_message, 00000, DateTime.now )
e.decrypt(output, 12345, Date.today)
=end

