require 'date'
require_relative 'keygen'

#Helper module contains commonly used helper methods that we will include in our classes
module Helper

	#check if message is nil or empty and throw an error
	def validate_message(message)
		if message.nil? || message.to_s.length == 0
			raise ArgumentError, "Message nil or invaild. Message must contain at least 1 character"
		else
			message
		end
	end

	def is_encrypted_message_valid?(message,num_digits)
		if message.to_s.length % num_digits == 0
			return true
		end
		
		false
	end

	#returns a valid date in the form 'ddmmyy' or throws an error if invalid argument is supplied
	def validate_date(date)

		#check if date is a time, date or datetime object
		if (date.is_a?Time) || (date.is_a?Date) || (date.is_a?DateTime)
			if date.respond_to?'strftime'
				return date.strftime('%d%m%y')
			else
				#invalid object type
				raise ArgumentError, "date: '#{date}' is an invalid date. Try: a date/time/datetime object or string in the form 'ddmmyy'"
			end
		#check if date is a valid date string
		elsif (date.is_a?String)
			if date.to_i > 0 && date.length == 6
				return date
			else
				#invalid string format
				raise ArgumentError, "date: '#{date}' is an invalid date. Try: a date/time/datetime object or string in the form 'ddmmyy'"
			end
		#return current date
		else
			Time.now.strftime('%d%m%y')
		end

	end

	#returns a padded valid key or one is generated if key is nil
	def validate_key(key)
		if key.nil?
			Keygen.new.create_new_key
		else
			"%05d" % key.to_i
		end
	end

	#returns an array representing the A,B,C,D rotation
	def process_rotation(key)
		#use range to process substrings of keys

		a = key[0..1]
		b = key[1..2]
		c = key[2..3]
		d = key[3..4]

		#return array of rotations
		[a,b,c,d]
	end

	#returns an array of offsets from date that correspond to each A,B,C,D position
	def process_offset(date)
		squared = date.to_i ** 2

		#return array of offsets
		a_offset = squared.to_s[-4]			
		b_offset = squared.to_s[-3]
		c_offset = squared.to_s[-2]
		d_offset = squared.to_s[-1]

		[a_offset,b_offset,c_offset,d_offset]
	end

end