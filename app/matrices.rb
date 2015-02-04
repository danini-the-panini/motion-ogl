include OpenGLHelper

module Matrices
  def self.perspective(fovy, aspect, zNear, zFar)
		halfFovyRadians = to_rad( (fovy / 2.0) )
		range = Math.tan(halfFovyRadians) * zNear
		left = -range * aspect
		right = range * aspect
		bottom = -range
		top = range

    Mat4.new(
      (2.0 * zNear) / (right - left), 0.0, 0.0, 0.0,
      0.0, (2.0 * zNear) / (top - bottom), 0.0, 0.0,
      0.0, 0.0, -(zFar + zNear) / (zFar - zNear), -1.0,
      0.0, 0.0, -(2.0 * zFar * zNear) / (zFar - zNear), 0.0
		)
  end

  def self.look_at(eye, center, up)
		f = (center - eye).normalize
		u = up.normalize
		s = f.cross(u).normalize
		u = s.cross(f)

    Mat4.from_arr [
      s.x, u.x, -f.x, 0.0,
      s.y, u.y, -f.y, 0.0,
      s.z, u.z, -f.z, 0.0,
      -s.dot(eye), -u.dot(eye), f.dot(eye), 1.0
		]
  end

  def self.rotate(phi, axis)
		rcos = Math.cos(phi)
		rsin = Math.sin(phi)

		x = axis.x
		y = axis.y
		z = axis.z

    v1 = Vec4.new(rcos + x * x * (1 - rcos),
                  z * rsin + y * x * (1 - rcos),
                  -y * rsin + z * x * (1 - rcos), 0)

    v2 = Vec4.new(-z * rsin + x * y * (1 - rcos),
                  rcos + y * y * (1 - rcos),
                  x * rsin + z * y * (1 - rcos), 0)

    v3 = Vec4.new(y * rsin + x * z * (1 - rcos),
                  -x * rsin + y * z * (1 - rcos),
                  rcos + z * z * (1 - rcos), 0)

    v4 = Vec4.new(0, 0, 0, 1)
    Mat4.from_vecs(v1, v2, v3, v4)
  end
end
