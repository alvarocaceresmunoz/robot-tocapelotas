class Handler
  def initialize()
  end

  def result(r)
    return r
  end

  #def process type, rest
    #case type
    #when :array
      #rest.map { |x| process(x.first, x.drop(1)) }
    #when :hash
      #Hash[rest.map { |x|
        #process(x.first, x.drop(1))
      #}.each_slice(2).to_a]
    #when :scalar
      #rest.first
    #end
  #end
end
