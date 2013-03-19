require 'helper'

class TagdataOutputTest < Test::Unit::TestCase
	def setup
		Fluent::Test.setup
	end

	DEFAULT_CONFIG = %[
		out_keys server,protocol,domain
		add_tag_prefix    filtered.
		remove_tag_prefix example.
	]

	def create_driver(conf = DEFAULT_CONFIG, tag='example.straycat.http.www.example.com')
		Fluent::Test::OutputTestDriver.new(Fluent::TagdataOutput, tag).configure(conf)
	end

	def test_configure
		# when 'out_keys' is set
		d = create_driver
		assert_equal 'server,protocol,domain', d.instance.out_keys
		assert_equal 'filterd.',               d.instance.add_tag_prefix
		assert_equal /^example\./,             d.instance.remove_tag_prefix
		
		# when 'out_keys' not set
		assert_raise(Fluent::ConfigError) do
			create_driver(%[
				add_tag_prefix    filtered.
				remove_tag_prefix example.
      ])
    end
	end

	def test_emit
		d = create_driver(DEFAULT_CONFIG)
		time = Time.now.to_i
		d.run do
			d.emit( {
				'host' => 'localhost',
				'user' => '-',
				'method' => 'GET',
				'path' => '/sample.html',
				'code' => '200',
				'size' => '1234',
				'referer' => '-',
				'agent' => 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22',
				'response' => '1234567' },
				time)
		end
		emits = d.emits

		assert_equal 1, emits.count

		assert_equal 'filtered.straycat.http.www.example.com', emits[0][0]
		assert_equal time, emits[0][1]

		assert_equal [
			'host','user','method','path','code','size','referer','agent','response',
			'server','protocol','domain'
		], emits[0][2].keys

		assert_equal 'straycat', emits[0][2]['server']
		assert_equal 'http', emits[0][2]['protocol']
		assert_equal 'www.example.com', emits[0][2]['domain']

	end
end
