class GLViewController < UIViewController

  def loadView
    self.view = GLView.alloc.init
  end

  def viewDidLoad
    super
  end

  def didReceiveMemoryWarning
    super
  end
end
