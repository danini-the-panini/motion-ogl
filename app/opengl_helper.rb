module OpenGLHelper
  def glGenBuffer
    pointer = Pointer.new(:uchar)
    glGenBuffers(1, pointer)
    pointer[0]
  end

  def to_ptr type, data
    pointer = Pointer.new(type, data.count)
    data.each_with_index do |d,i|
      pointer[i] = d
    end
    pointer
  end

  def to_rad x
    GLKMathDegreesToRadians x
  end

  def to_deg x
    GLKMathRadiansToDegrees x
  end

  def ptr_to object
    Pointer.new(object.class.type).tap do |p|
      p.assign object
    end
  end
end
