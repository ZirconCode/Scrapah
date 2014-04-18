

require 'json'

module Scrapah

	class FileCache < Cache

		# !!!!!!!!!
		# TODO use file_storage system?
		# or simply use current storage system?
		# can set which type of storage to use?

		# TODO: 'throws away' whole cache after timeout, 
		# 	    -> treat entries as seperate objects/files/dates
		# !!!!!!!!!

		@@cache_dir = 'cache/'

		def initialize()
			Dir.mkdir(@@cache_dir) unless File.exists?(@@cache_dir)
			@Cache = Hash.new
			@keep_time = 1*24*60 # in minutes
		end

		def store(key,content)
			@Cache[key] = content
		end

		def get(key)
			@Cache[key]
		end

		def has_key?(key)
			@Cache.has_key? key
		end

		def clear()
			@Cache = Hash.new
		end

		def save
			# WARNING: Symbols converted to Strings
			f = File.new(@@cache_dir+Time.now.to_i.to_s,'w')
			JSON.dump(@Cache,f)
			f.close
		end


		def load
			f = get_newest_acceptable
			@Cache = Hash.new
			@Cache = JSON.load(f) unless f.nil?
			f.close

			@Cache
		end

		def get_hash
			@Cache
		end

		private

			def get_newest_acceptable()
				prev = Dir.glob(@@cache_dir+'*')
				if(!prev.empty?)
					prev.map!{|f| f.delete(@@cache_dir).to_i}
					prev.sort!
					return File.new(@@cache_dir+prev.last.to_s,"r") if(Time.now.to_i-prev.last < @keep_time*60)
				end

				nil
			end

	end

end