class Vec4 < Vec
  def initialize x, y, z, w
    @v = [x,y,z,w]
  end

  def self.from_arr a
    Vec4.new a[0], a[1], a[2], a[3]
  end

  def self.with_vec3 v, s = 0.0
    Vec4.new v.x, v.y, v.z, s
  end

  def % mat
    Vec4.new(
      mat.m00 * x + mat.m01 * y + mat.m02 * z + mat.m03 * w,
      mat.m10 * x + mat.m11 * y + mat.m12 * z + mat.m13 * w,
      mat.m20 * x + mat.m21 * y + mat.m22 * z + mat.m23 * w,
      mat.m30 * x + mat.m31 * y + mat.m32 * z + mat.m33 * w
		)
  end

  def x
    @v[0]
  end

  def y
    @v[1]
  end

  def z
    @v[2]
  end

  def w
    @v[3]
  end

  def xyz
    Vec3.from_arr @v[0..2]
  end
end
