module Fluent
	class TagdataOutput < Output
		include Fluent::HandleTagNameMixin
		class Error < StandardError; end

		Fluent::Plugin.register_output('tagdata', self)

		config_param :out_keys, :default => [] do |val|
			val.split(',')
		end
		config_param :firstpoint, :integer, :default => 1

		def configure(conf)
			super
			if @out_keys.empty?
				raise ConfigError, "out_tagdata: out_keys option is required on out_tagdata output."
			end
			if @firstpoint < 0
				raise ConfigError, "out_tagdata: firstpoint option is required a zero or positive number."
			end
		end

		def emit(tag, es, chain)
			es.each do |time,record|
				tagd = tag.dup
				get_mapped_tag_to_out_keys(tagd, time, record)
				filter_record(tagd, time, record)
				Fluent::Engine.emit(tag, time, record)
			end
			chain.next
		end

		def get_mapped_tag_to_out_keys(tag, time, record)
			tags = tag.split('.')
			@firstpoint.times do
				tags.shift
			end
			tagdata = {}
			key_end = nil
			@out_keys.each do |key,value|
				tagdata.store( key, tags.shift )
				key_end = key
			end
			if !tags.empty?
				tagdata[key_end] = tagdata[key_end] + '.' + tags.join('.')
			end
			tagdata.each do |key,value|
				record[key] = value
			end
		end
	end
end
