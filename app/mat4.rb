class Mat4 < Struct.new(:m00, :m01, :m02, :m03, :m10, :m11, :m12, :m13, :m20, :m21, :m22, :m23, :m30, :m31, :m32, :m33)
  include OpenGLHelper

  def to_arr
    [m00, m01, m02, m03,
     m10, m11, m12, m13,
     m20, m21, m22, m23,
     m30, m31, m32, m33]
  end

  def ptr
    to_ptr :float, self.to_arr
  end

  def self.from_diagonal s
    Mat4.new(
      s, 0.0, 0.0, 0.0,
      0.0, s, 0.0, 0.0,
      0.0, 0.0, s, 0.0,
      0.0, 0.0, 0.0, s
    )
  end

  def * right
    nm00 = self.m00 * right.m00 + self.m10 * right.m01 + self.m20 * right.m02 + self.m30 * right.m03
    nm01 = self.m01 * right.m00 + self.m11 * right.m01 + self.m21 * right.m02 + self.m31 * right.m03
    nm02 = self.m02 * right.m00 + self.m12 * right.m01 + self.m22 * right.m02 + self.m32 * right.m03
    nm03 = self.m03 * right.m00 + self.m13 * right.m01 + self.m23 * right.m02 + self.m33 * right.m03
    nm10 = self.m00 * right.m10 + self.m10 * right.m11 + self.m20 * right.m12 + self.m30 * right.m13
    nm11 = self.m01 * right.m10 + self.m11 * right.m11 + self.m21 * right.m12 + self.m31 * right.m13
    nm12 = self.m02 * right.m10 + self.m12 * right.m11 + self.m22 * right.m12 + self.m32 * right.m13
    nm13 = self.m03 * right.m10 + self.m13 * right.m11 + self.m23 * right.m12 + self.m33 * right.m13
    nm20 = self.m00 * right.m20 + self.m10 * right.m21 + self.m20 * right.m22 + self.m30 * right.m23
    nm21 = self.m01 * right.m20 + self.m11 * right.m21 + self.m21 * right.m22 + self.m31 * right.m23
    nm22 = self.m02 * right.m20 + self.m12 * right.m21 + self.m22 * right.m22 + self.m32 * right.m23
    nm23 = self.m03 * right.m20 + self.m13 * right.m21 + self.m23 * right.m22 + self.m33 * right.m23
    nm30 = self.m00 * right.m30 + self.m10 * right.m31 + self.m20 * right.m32 + self.m30 * right.m33
    nm31 = self.m01 * right.m30 + self.m11 * right.m31 + self.m21 * right.m32 + self.m31 * right.m33
    nm32 = self.m02 * right.m30 + self.m12 * right.m31 + self.m22 * right.m32 + self.m32 * right.m33
    nm33 = self.m03 * right.m30 + self.m13 * right.m31 + self.m23 * right.m32 + self.m33 * right.m33

    Mat4.new(
      nm00, nm01, nm02, nm03,
      nm10, nm11, nm12, nm13,
      nm20, nm21, nm22, nm23,
      nm30, nm31, nm32, nm33
    )
  end

  def self.from_arr a
    Mat4.new(*a)
  end

  def self.from_vecs a, b, c, d
    Mat4.new(*a.to_arr, *b.to_arr, *c.to_arr, *d.to_arr)
  end
end
