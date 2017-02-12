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

    # flatten the path into single level segments
    segments = self.flatten_string( path_to_get ).split('.')

    # for each segment, get object_id and set into id
    segments.each do |segment|

      # get the object
      a = ObjectSpace._id2ref(id)

      # create the segment if not present
      a[segment] = {} if not a.has_key?(segment)

      # note the id of this segment
      id = a[segment].object_id
    end

    a = ObjectSpace._id2ref(id)

    self.log "get out #{path_to_get} to #{a}"
    a
  end

  def flatten_string(s)
    while s.include?('{')
      token = s.split('}').first.split('{').last
      self.log " flat #{token} | #{s}"
      value = self.get(token)
      s.gsub!("{#{token}}",value)
    end
    return s
  end

  def set(path_to_set, path_to_value, value=nil)
    self.log "set in #{path_to_set} to #{path_to_value} #{value}"
    # start with the @data id
    id = @store.object_id

    # get the path to, and the tail attr string
    *segments, tail = self.flatten_string( path_to_set ).split('.')

    # for each path segment, set id to that object_id
    segments.each do |segment|
      a = ObjectSpace._id2ref(id)

      # create the segment if not present
      a[segment] = {} if not a.has_key?(segment)

      # note the id of this segment
      id = a[segment].object_id
    end

    # lookup the final object
    obj = ObjectSpace._id2ref(id)


    # assign path a value
    if value.nil?

      #  get value at path
      value = self.resolve( self.flatten_string(path_to_value) )

    end

    # set our path+tail to value
    obj[tail] = value

    self.log "set out #{path_to_set} to #{value}"

  end

  def resolve(path_to_value)
    path = path_to_value.split('.')

    # route rpc calls into functions
    if path.first == 'rpc'
      # todo
    else
      value = @store.dig(*path)
    end

    # raise if value is nil... means failed lookup
    raise ArgumentError, 'path_to_value does not exist at this time' if value.nil?

    value
  end

  def import(path, value)
    # imports get set via value, not relative path
    self.set(path, nil, value)
  end

  def export()
    @store
  end

  def log(msg)
    puts "  debug: #{msg}" if @debug
  end

end