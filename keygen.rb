class Keygen
	def create_new_key
		#"%05d" % Random.new.rand(99999)
		Random.new.rand(99999).to_s.rjust(5,'0')

	end
end