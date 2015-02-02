class Camera
  def initialize
    @eye = GLKVector3Make 0.0, 5.0, 0.0
    @at = GLKVector3Make 0.0, 0.0, 0.0
    @up = GLKVector3Make 0.0, 1.0, 0.0
    recalc
  end

  def view_matrix
    GLKMatrix4MakeLookAt(@eye.x, @eye.y, @eye.z,
                         @at.x, @at.y, @at.x,
                         @up.x, @up.y, @up.z)
  end

  def orbit dx, dy
    newDy = dy

    gimbalRemainingCos = GLKVector3DotProduct(GLKVector3Negate(dir), up)
    gimbalRemaining = GLKMathRadiansToDegrees(Math::acos(Math::abs(gimbalRemainingCos)))
    if gimbalRemainingCos < 0
      if dy < 0 && gimbalRemaining - Math::abs(dy) < GIMBAL_LIMIT
        newDy = -gimbalRemaining + GIMBAL_LIMIT
      end
    else
      if dy > 0 && gimbalRemaining - Math::abs(dy) < GIMBAL_LIMIT
        newDy = gimbalRemaining - GIMBAL_LIMIT
      end
    end

    m = GLKMatrix4RotateWithVector3(GLKMatrix4Identity, newDy, @right)
    m = GLKMatrix4Rotate(m, -dx, 0.0, 1.0, 0.0)
    d2 = GLKMatrix4MultiplyVector4(m, GLKVector4MakeWithVector3(@dir, 0.0))
    @eye = GLKVector3Subtract(at, GLKVector3MultiplyScalar(GLKVector3Normalize(vec4_xyz(d2)), dist))
    recalc
  end

  def zoom s
    @eye = GLKVector3Subtract(at, GLKVector3MultiplyScalar(dir, dist * s))
    recalc
  end

  private
  def recalc
    @up = GLKVector3Normalize(up)
    @dir = GLKVector3Normalize(GLKVector3Subtract(at, eye))
    @right = GLKVector3Normalize(GLKVector3CrossProduct(up, dir))
  end

  def dist
    GLKVector3Length(GLKVector3Subtract(at, eye))
  end

  def vec4_to_arr v
    [v.x, v.y, v.z]
  end

  def vec4_xyz v
    GLKVector3Make v.x, v.y, v.z
  end
end
