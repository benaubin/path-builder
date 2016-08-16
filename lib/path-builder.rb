class PathBuilder
  def initialize
    @path = self.class.base_path.dup
  end

  class <<self
    def base_path=(path)
      @base_path = path
    end
    def base_path
      @base_path ||= []
    end
    def [](*args)
      if @base_args
        @base_args += args
      else
        @base_args = args
      end
      self
    end
    def base_args=(v)
      @base_args = v
    end
    def base_args
      @base_args ||= []
    end
    def break_on_empty
      @break_on_empty
    end
    def break_on_empty=(v)
      @break_on_empty = v
    end
  end

  # Add a segment (string)
  def method_missing(segment, *args)
    @path << segment.to_s
    @path += args.map{ |a| a.to_sym }
    self
  end

  # Add a variable segment (symbol)
  def call(segment)
    @path << segment.to_sym
    self
  end

  # Add a segment (string)
  def []=(*args)
    if args.length = 1
      segment = *args
      @path << segment.to_s if segment
    else
      variable_segment, *segment = *args
      @path << variable_segment.to_sym if variable_segment
      @path += segment.map(&:to_s)
    end
    self
  end

  def [](*args, break_on_empty: self.class.break_on_empty)
    args += self.class.base_args.dup
    @path.map do |segment|
      if segment.is_a? Symbol
        args.shift || (break_on_empty ? nil : segment)
      else
        segment
      end
    end.take_while{|i|i}.join('/') << '/'
  end
  alias :to_s :[]

  def -(number)
    @path.pop number
  end

  def save!(break_on_empty: self.class.break_on_empty)
    klass = Class.new self.class
    klass.base_path = @path
    klass.break_on_empty = break_on_empty
    klass
  end

  def inspect
    "#<#{self.class.name} /#{@path.map(&:inspect).join('/')}>"
  end
end
