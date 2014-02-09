# fluent-plugin-tagdata, a plugin for [Fluentd](http://fluentd.org)

Fluentd plugin to put the tag records in the data.

## Component

### Output

Fluentd plugin to put the tag records in the data.

## Synopsis

Imagin you have a config as below:

```
<match example.**>
  type tagdata
  out_keys server,protocol,domain
  add_tag_prefix    filtered.
  remove_tag_prefix example.
</match>
```

And you feed such a value into fluentd:

```
"example.straycat.http.www.example.com" => {
  "host":"localhost",
	"user":"-",
	"method":"GET",
	"path":"/sample.html",
	"code":"200",
	"size":"1234",
	"referer":"-",
	"agent":"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22",
	"response":"1234567"
}
```

Then you'll get re-emmited tag/record below:

```
"filtered.straycat.http.www.example.com" => {
  "host":"localhost",
	"user":"-",
	"method":"GET",
	"path":"/sample.html",
	"code":"200",
	"size":"1234",
	"referer":"-",
	"agent":"Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.172 Safari/537.22",
	"response":"1234567",
	"server":"straycat",
	"protocol":"http",
	"domain":"http.www.example.com"
}
```

## Configuration

### out_keys

The `out_keys` is used to point keys whose value contains CSV-formatted string.

### firstpoint

The `firstpoint` is used to a first point number of piriod-separated-tags.
Default value is 1.

### remove_tag_prefix, remove_tag_suffix, add_tag_prefix, add_tag_suffix

These params are included from `Fluent::HandleTagNameMixin`. See that code for details.

You must add at least one of these params.

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-tagdata'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-tagdata

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

### Copyright

Copyright (c) 2013- Fukui Masayuki (@msfukui)

### License

Apache License, Version 2.0
