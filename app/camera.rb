include OpenGLHelper

class Camera
  GIMBAL_LIMIT = 5

  def initialize
    @eye = [0.0, 5.0, 0.0]
    @at = [0.0, 0.0, 0.0]
    @up = [0.0, 1.0, 0.0]
    recalc
  end

  def view_matrix
    GLKMatrix4MakeLookAt(*@eye, *@at, *@up)
  end

  def orbit dx, dy
    newDy = dy

    gimbalRemainingCos = dot(negate(@dir), @up)
    gimbalRemaining = GLKMathRadiansToDegrees(
      Math::acos(abs(gimbalRemainingCos)))
    if gimbalRemainingCos < 0
      if dy < 0 && gimbalRemaining - abs(dy) < GIMBAL_LIMIT
        newDy = -gimbalRemaining + GIMBAL_LIMIT
      end
    else
      if dy > 0 && gimbalRemaining - abs(dy) < GIMBAL_LIMIT
        newDy = gimbalRemaining - GIMBAL_LIMIT
      end
    end

    m = GLKMatrix4RotateWithVector3(GLKMatrix4Identity, newDy, [@right])
    m = GLKMatrix4Rotate(m, -dx, 0.0, 1.0, 0.0)
    d2 = vec4_to_arr GLKMatrix4MultiplyVector4(m, [@dir+[0.0]])
    @eye = subtract(@at, scale(normalize(d2[0..2]), dist))
    recalc
  end

  def zoom s
    @eye = scale(@at, scale(@dir, dist * s))
    recalc
  end

  private
  def recalc
    @up = normalize(@up)
    @dir = normalize(subtract(@at, @eye))
    @right = normalize(cross(@up, @dir))
  end

  def abs x
    x < 0 ? -x : x
  end

  def negate v
    scale v, -1.0
  end

  def scale v, s
    v.map { |i| i * s }
  end

  def add a, b
    a.zip(b).map { |i,j| i + j }
  end

  def subtract a, b
    add a, negate(b)
  end

  def dist
    length(subtract(@at, @eye))
  end

  def dot a, b
    a.zip(b).map { |i,j| i * j }.reduce(:+)
  end

  def length v
    Math.sqrt(dot(v,v))
  end

  def normalize v
    scale v, 1.0/length(v)
  end

  def cross a, b
    [
      a[1] * b[2] - b[1] * a[2],
      a[2] * b[0] - b[2] * a[0],
      a[0] * b[1] - b[0] * a[1]
    ]
  end
end
