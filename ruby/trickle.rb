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

class Trickle
  attr_accessor :debug

  def initialize(store = {})
    @store = store
    @debug = false
  end

  def get(path_to_get)
    self.log "get in #{path_to_get}"
    id = @store.object_id
    segments = self.flatten_string( path_to_get ).split('.')
    segments.each do |segment|
      a = ObjectSpace._id2ref(id)
      a[segment] = {} if not a.has_key?(segment)
      id = a[segment].object_id
    end
    a = ObjectSpace._id2ref(id)
    self.log "get out #{path_to_get} to #{a}"
    a
  end

  def set(path_to_set, path_to_value, value=nil)
    self.log "set in #{path_to_set} to #{path_to_value} #{value}"
    id = @store.object_id
    *segments, tail = self.flatten_string( path_to_set ).split('.')
    segments.each do |segment|
      a = ObjectSpace._id2ref(id)
      a[segment] = {} if not a.has_key?(segment)
      id = a[segment].object_id
    end
    obj = ObjectSpace._id2ref(id)
    value = self.resolve( self.flatten_string(path_to_value) ) if value.nil?
    obj[tail] = value
    self.log "set out #{path_to_set} to #{value}"
  end

  def flatten_string(s)
    while s.include?('{')
      token = s.split('}').first.split('{').last
      self.log " flat #{token} | #{s}"
      value = self.get(token)
      s.gsub!("{#{token}}",value)
    end
    s
  end

  def resolve(path_to_value)
    path = path_to_value.split('.')
    if path.first == 'rpc'
      # todo
    else
      value = @store.dig(*path)
    end
    raise ArgumentError, 'path_to_value does not exist at this time' if value.nil?
    value
  end

  def import(path, value)
    self.set(path, nil, value)
  end

  def export()
    @store
  end

  def log(msg)
    puts "  debug: #{msg}" if @debug
  end

end