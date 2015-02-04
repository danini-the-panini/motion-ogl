include OpenGLHelper

class MonkeyViewController < GLKViewController
  TOUCH_SCALE_FACTOR = 0.5625
  PINCH_SCALE_FACTOR = 1

  MAT4_ZERO = Mat4.from_diagonal 0.0
  MAT4_IDENTITY = Mat4.from_diagonal 1.0

  def loadView
    self.view = GLKView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.view.drawableDepthFormat = GLKViewDrawableDepthFormat24
  end

  def setupGL
    EAGLContext.setCurrentContext(@context)
  end

  def tearDownGL
    EAGLContext.setCurrentContext(@context)
  end

  def viewDidLoad
    super
    @context = EAGLContext.alloc.initWithAPI(KEAGLRenderingAPIOpenGLES2)
    if (!@context)
      puts "Failed to create ES context"
    end
    self.view.context = @context
    setupGL
    surfaceCreated
    viewDidLayoutSubviews
  end

  def viewDidUnload
    super
    tearDownGL
    if (EAGLContext.currentContext == @context)
      EAGLContext.setCurrentContext(nil)
    end
    @context = nil
  end

  def viewDidLayoutSubviews
    UIScreen.mainScreen.bounds.tap do |bounds|
      surfaceChanged bounds.size.width, bounds.size.height
    end
  end

  def surfaceCreated
    glClearColor(0, 1, 1, 1)

    @mesh = WavefrontMesh.new pathForResource('monkey.obj')
    @shader = Shader.new pathForResource('vertex.glsl'), pathForResource('fragment.glsl')

    @mesh.load
    @shader.load.use

    colorHandle = glGetUniformLocation(@shader.handle, "vColor")
    glUniform4fv(colorHandle, 1, to_ptr(:float, [1.0, 0.0, 0.0, 1.0]))

    @worldHandle = glGetUniformLocation(@shader.handle, "world")
    @projHandle = glGetUniformLocation(@shader.handle, "projection")
    @viewHandle = glGetUniformLocation(@shader.handle, "view")

    @camera = Camera.new 5.0, 0.0, 0.0
  end

  def surfaceChanged width, height
    glViewport(0, 0, width, height)

    ratio = width.to_f / height.to_f

    @projectionMatrix = Matrices.perspective(60.0, ratio, 0.1, 100.0)
    glUniformMatrix4fv(@projHandle, 1, GL_FALSE, @projectionMatrix.ptr)
  end

  def glkView(view, drawInRect:rect)
    glEnable(GL_DEPTH_TEST)
    glDepthFunc(GL_LEQUAL)
    glEnable(GL_CULL_FACE)
    glCullFace(GL_BACK)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    glUniformMatrix4fv(@viewHandle, 1, GL_FALSE, @camera.view_matrix.ptr)

    glUniformMatrix4fv(@worldHandle, 1, GL_FALSE, MAT4_IDENTITY.ptr)

    @mesh.draw(@shader)
  end

  def update
  end

  def didReceiveMemoryWarning
    super
  end

  def touchesBegan touches, withEvent: event
    location = touches.anyObject.locationInView(self.view)
    @prevX = location.x
    @prevY = location.y
  end

  def touchesMoved touches, withEvent: event
    location = touches.anyObject.locationInView(self.view)

    dx = location.x - @prevX
    dy = location.y - @prevY

    @camera.orbit(dx * TOUCH_SCALE_FACTOR, dy * TOUCH_SCALE_FACTOR)

    @prevX = location.x
    @prevY = location.y
  end

  def touchesEnded touches, withEvent: event
  end

  def touchesCancelled touches, withEvent: event
  end

  private
  def pathForResource file
    ext = File.extname file
    name = File.basename file, ext

    NSBundle.mainBundle.pathForResource(name, ofType: ext)
  end
end
