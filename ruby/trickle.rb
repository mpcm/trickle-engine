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
  attr_accessor :store

  def initialize(store = {})
    @store = store
  end

  def get(data_path)
    id = @store.object_id

    # for each segment, get object_id and set into id
    path_to_set.split('.').each do |segment|

      # binding.pry
      a = ObjectSpace._id2ref(id)

      # create the segment if not present
      a[segment] = {} if not a.has_key?(segment)

      # note the id of this segment
      id = a[segment].object_id
    end

    a = ObjectSpace._id2ref(id)

  end

  def set(path_to_set, path_to_value, value=nil)

    # start with the @data id
    id = @store.object_id

    # get the path to, and the tail attr string
    *segments, tail = path_to_set.split('.')

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

      # resolve path value
      value = @store.dig(*path_to_value.split('.'))

      # explode if value is nil... means failed lookup
      raise ArgumentError, 'path_to_value does not exist at this time' if value.nil?

    end

    # set our path+tail to value
    obj[tail] = value

  end

  def import(data_path, value)
    self.set(data_path, '', value)
  end

  def export()
    @store
  end

end