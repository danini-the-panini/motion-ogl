class Shader
  def initialize vertexPath, fragmentPath
    @vertexPath = vertexPath
    @fragmentPath = fragmentPath
  end

  def handle
    @handle
  end

  def load
    vertexShader = loadShader(GL_VERTEX_SHADER, File.read(@vertexPath))
    fragmentShader = loadShader(GL_FRAGMENT_SHADER, File.read(@fragmentPath))

    @handle = glCreateProgram
    glAttachShader(@handle, vertexShader)
    glAttachShader(@handle, fragmentShader)
    glLinkProgram(@handle)

    self
  end

  def loadShader type, source
    glCreateShader(type).tap do |shader|
      glShaderSource(shader, 1, string_to_ptr(source), nil)
      glCompileShader(shader)
    end
  end

  def use
    glUseProgram(@handle)
    self
  end

  private
  def string_to_ptr string
    pointer = Pointer.new :char, string.bytesize
    string.each_byte.each_with_index do |b,i|
      pointer[i] = b
    end
    Pointer.new(:string, 1).tap do |ptr|
      ptr.assign pointer
    end
  end
end
