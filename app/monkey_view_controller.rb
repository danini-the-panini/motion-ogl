include OpenGLHelper

class MonkeyViewController < GLKViewController

  def loadView
    self.view = GLKView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
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
    glClearColor(0, 0, 0, 1)
    glEnable(GL_DEPTH_TEST)
    glEnable(GL_CULL_FACE)

    @mesh = WavefrontMesh.new pathForResource('monkey.obj')
    @shader = Shader.new pathForResource('vertex.glsl'), pathForResource('fragment.glsl')

    @mesh.load
    @shader.load.use

    colorHandle = glGetUniformLocation(@shader.handle, "vColor")
    glUniform4fv(colorHandle, 1, to_ptr(:float, [1.0, 0.0, 1.0, 1.0]))

    @worldHandle = glGetUniformLocation(@shader.handle, "world")
    @projHandle = glGetUniformLocation(@shader.handle, "projection")
    @viewHandle = glGetUniformLocation(@shader.handle, "view")
  end

  def surfaceChanged width, height
    puts "Surface changed to #{width}, #{height}"
  end

  def glkView(view, drawInRect:rect)
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)

    @mesh.draw(@shader)
  end

  def didReceiveMemoryWarning
    super
  end

  private
  def pathForResource file
    ext = File.extname file
    name = File.basename file, ext

    NSBundle.mainBundle.pathForResource(name, ofType: ext)
  end
end
