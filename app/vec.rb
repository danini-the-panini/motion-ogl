class Vec
  include OpenGLHelper

  def to_arr
    @v
  end

  def ptr
    to_ptr :float, @v
  end

  def -@
    self * -1.0
  end

  def * s
    from_arr(@v.map { |i| i * s })
  end

  def + b
    from_arr(@v.zip(b.to_arr).map { |i,j| i + j })
  end

  def - b
    self + (-b)
  end

  def dot b
    @v.zip(b.to_arr).map { |i,j| i * j }.reduce(:+)
  end

  def length
    Math.sqrt(dot(self))
  end

  def normalize
    self * (1.0/length)
  end

  private
  def from_arr a
    self.class.from_arr a
  end
end
