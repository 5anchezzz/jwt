def query(params)
  # this magic method prepares sql and gets correct data from DB
  # NO CHANGES HERE
  puts "Params = #{params}"
  [
    {name: "John", surname: "Doe", age: 33},
    {name: "John", surname: "Doe", age: 34},
    {name: "John", surname: "Doe", age: 35}
  ]
end

class ActiveRecordN
  attr_accessor :where_params, :order_params

  def initialize
    @where_params = {}
    @order_params = ''
  end

  def where(**args)
    where_params.merge!(args)
    self
  end

  def order(arg)
    @order_params = arg
    self
  end

  def map
    return self unless block_given?

    res = []
    query({where_params: where_params, order_params: order_params}).each do |element|
      res << yield(element)
    end

    res
  end

  class << self
    def where(**args)
      self.new().where(args)
    end

    def order(arg)
      self.new().order(arg)
    end
  end
end