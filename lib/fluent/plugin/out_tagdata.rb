module Fluent
	class TagdataOutput < Output
		include Fluent::HandleTagNameMixin
		class Error < StandardError; end

		Fluent::Plugin.register_output('tagdata', self)

		config_param :out_keys, :default => [] do |val|
			val.split(',')
		end

		def configure(conf)
			super
			if @out_keys.empty?
				raise ConfigError, "out_tagdata: out_keys option is required on out_tagdata output."
			end
		end

		def emit(tag, es, chain)

			tags = tag.split('.')
			tagdata = {}
			@out_keys.each do |key,value|
				tagdata.store( value, tags.shift )
				value_end = value
			end
			if tags.empty?
				tagdata[value_end] = tags.join('.')
			end

			es.each do |time,record|
				tagdata.each do |key,value|
					record[key] = value
				end
				Fluent::Engine.emit(tag, time, record)
			end
			chain.next

		end
	end
end
