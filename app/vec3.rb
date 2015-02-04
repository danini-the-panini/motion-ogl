class Vec3 < Vec
  def initialize x, y, z
    @v = [x,y,z]
  end

  def self.from_arr a
    Vec3.new a[0], a[1], a[2]
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

  def cross b
    from_arr [
      y * b.z - b.y * z,
      z * b.x - b.z * x,
      x * b.y - b.x * y
    ]
  end
end
