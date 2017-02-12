require 'rubygems'
require 'bundler/setup'
require 'json'

require './trickle'

require 'pry'
require 'pry-byebug'
require 'pp'

# Trigger - array jsons path to watch
# Impact - array json path to set
# Value - array json path to use in set
# Condition - obj representing condition (if conditional)
# [[data.field1, op.eq, fact.fact1], op.and, [data.field2, op.gteq, fact.fact2]]
# Trickle - array json path to true/false value


# A rpc. namespace should be reserved in which to perform non-trivial-matrixized processes
# A data. namespace should be reserved for the current data object scope
# A fact. namespace should be reserved for table facts
# A op. namespace should be reserved for operations like &&, ||, ==, >=


e = Trickle.new()
# e.debug = true
e.import 'facts', {
	'13_82_bil' => 13820000000000,
	'1321009871' => 'November 11, 2011',
	'weather_1' => 'sunny',
	'weather_2' => 'rainy',
	'weather_3' => 'snowy',
}

e.import 'map', {
	'alias1' => 'aquarius',
	'alias2' => 'alias1',
	'alias3' => 'alias2',
	'alias4' => 'map.alias1',
}

# basic path get/set
e.set 'data.age.of.universe','facts.13_82_bil'
e.set 'data.age.of.aquarius','facts.1321009871'

# dynamic path resolution
e.get 'data.age.of.{map.alias1}'             # aquarius
e.get 'data.age.of.{map.{map.alias2}}'       # aquarius
e.get 'data.age.of.{map.{map.{map.alias3}}}' # aquarius
e.get 'data.age.of.{{map.alias4}}'           # aquarius

# set the weather
e.set 'data.age.of.{map.alias1}_weather','facts.weather_1'
e.set 'data.age.of.{map.{map.alias2}}_weather','facts.weather_2'
e.set 'data.age.of.{map.{map.{map.alias3}}}_weather','facts.weather_3'


puts "="*50
pp e.export['data']

# puts "="*50
# pp e.export