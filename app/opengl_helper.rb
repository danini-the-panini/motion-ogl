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

  def ptr_to object
    Pointer.new(object.class.type).tap do |p|
      p.assign object
    end
  end

  def vec4_to_arr v
    p = GLKHelper.GLKVector4ToArray(ptr_to(v))
    4.times.map { |i| p[i] }
  end

  def vec3_to_arr v
    p = GLKHelper.GLKVector3ToArray(ptr_to(v))
    3.times.map { |i| p[i] }
  end
end
