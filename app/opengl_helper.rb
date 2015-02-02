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

  def matrix_ptr matrix
    Pointer.new(GLKMatrix4.type).tap do |ptr|
      ptr.assign matrix
      ptr.cast!(:float)
    end
  end
end
