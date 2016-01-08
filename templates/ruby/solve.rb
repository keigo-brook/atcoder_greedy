# coding: utf-8
require 'stringio'

class NAME
  alias :puts_original :puts
  def initialize(input)
    @f = StringIO.new(input)
  end

  def gets
    @f.gets
  end

  def puts(a)
    puts_original a
    a
  end

  def solve
    # write your program here
  end
end