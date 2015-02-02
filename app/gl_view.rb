class GLView < UIView
  def layerClass
    CAEAGLLayer
  end

  def init
    super

    setupLayer
    setupContext
    setupRenderBuffer
    setupFrameBuffer

    onSurfaceCreated
    onSurfaceChanged frame.size.width, frame.size.height
    onDrawFrame
  end

  def setupLayer
  end

  def setupContext
  end

  def setupRenderBuffer
  end

  def setupFrameBuffer
  end

  def onSurfaceCreated
  end

  def onSurfaceChanged w, h
  end

  def onDrawFrame
  end
end
