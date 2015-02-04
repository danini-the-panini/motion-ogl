include OpenGLHelper

class Camera
  GIMBAL_LIMIT = 5

  def initialize x, y, z
    @eye = Vec3.new x, y, z
    @at = Vec3.new 0.0, 0.0, 0.0
    @up = Vec3.new 0.0, 1.0, 0.0
    recalc
  end

  def view_matrix
    Matrices.look_at(@eye, @at, @up)
  end

  def orbit dx, dy
    newDy = -dy

    gimbalRemainingCos = (-@dir).dot(@up)
    gimbalRemaining = to_deg(Math::acos(abs(gimbalRemainingCos)))
    if gimbalRemainingCos < 0
      if dy < 0 && gimbalRemaining - abs(dy) < GIMBAL_LIMIT
        newDy = -gimbalRemaining + GIMBAL_LIMIT
      end
    else
      if dy > 0 && gimbalRemaining - abs(dy) < GIMBAL_LIMIT
        newDy = gimbalRemaining - GIMBAL_LIMIT
      end
    end

    m = Matrices.rotate(to_rad(newDy), @right)
    m *= Matrices.rotate(to_rad(dx), Vec3.new(0.0, 1.0, 0.0))
    d2 = Vec4.with_vec3(@dir) % m

    @eye = @at - (d2.xyz.normalize * dist)
    recalc
  end

  def zoom s
    @eye = @at - (@dir * (dist * s))
    recalc
  end

  private
  def recalc
    @up = @up.normalize
    @dir = (@at - @eye).normalize
    @right = @up.cross(@dir).normalize
  end

  def abs x
    x < 0 ? -x : x
  end

  def dist
    (@at - @eye).length
  end

end
