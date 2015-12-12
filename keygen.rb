class Keygen
	def create_new_key
		"%05d" % Random.new.rand(99999)
	end
end