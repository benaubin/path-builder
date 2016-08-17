class PathBuilder
  def initialize(*args)
    @path = self.class.base_path.dup
    @args = self.class.base_args.dup
    self.call(*args)
  end

  class <<self
    def version
      "0.1.2"
    end
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
      @break_on_empty.nil? ? superclass.respond_to?(:break_on_empty) && superclass.break_on_empty : @break_on_empty
    end
    def break_on_empty=(v)
      @break_on_empty = v
    end
  end

  # Add a static segment (string)
  def method_missing(segment, *args)
    @path << segment.to_s
    @path += args.map{ |a| a.to_sym }
    self
  end

  # Add a segment (symbol: variable, string: static)
  def call(*segments)
    @path += segments
    self
  end

  def [](*args, break_on_empty: self.class.break_on_empty)
    @args += args
    @path.map do |segment|
      if segment.is_a? Symbol
        @args.shift || (break_on_empty ? nil : segment)
      else
        segment
      end
    end.take_while{|i|i}.join('/') << '/'
  end
  alias :to_s :[]

  def -(number)
    @path.pop number
  end

  def +(other)
    @path += other.path!
    @args += other.args!
    self
  end

  def path!
    @path
  end

  def args!
    @args
  end

  def save!(break_on_empty: nil)
    klass = Class.new self.class
    klass.base_path = @path
    klass.break_on_empty = break_on_empty unless break_on_empty.nil?
    klass
  end

  def inspect
    "#<#{self.class.name} /#{@path.map(&:inspect).join('/')}>"
  end
end
