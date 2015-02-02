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
end
