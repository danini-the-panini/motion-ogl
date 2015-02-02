include OpenGLHelper

class WavefrontMesh
  BYTES_PER_FLOAT = 4
  BYTES_PER_INT = 4
  FLOATS_PER_VECTOR = 3
  VECTORS_PER_ELEMENT = 2
  FLOATS_PER_ELEMENT = FLOATS_PER_VECTOR * VECTORS_PER_ELEMENT
  BYTES_PER_VECTOR = BYTES_PER_FLOAT * FLOATS_PER_VECTOR
  BYTES_PER_ELEMENT = BYTES_PER_FLOAT * FLOATS_PER_ELEMENT

  def initialize filePath
    @filePath = filePath
    @points = []
    @normals = []
    @indices = []
    @normal_indices = []
  end

  def load
    load_file
    align_normals
    pack_vertices
    load_opengl
  end

  def draw shader
    glBindBuffer(GL_ARRAY_BUFFER, @vertexHandle)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, @indexHandle)

    positionAttr = glGetAttribLocation(shader.handle, "vPosition")
    glEnableVertexAttribArray(positionAttr)
    glVertexAttribPointer(positionAttr, FLOATS_PER_VECTOR, GL_FLOAT, GL_FALSE, BYTES_PER_ELEMENT,
                          Pointer.magic_cookie(0))

    normalAttr = glGetAttribLocation(shader.handle, "vNormal")
    glEnableVertexAttribArray(normalAttr)
    glVertexAttribPointer(normalAttr, FLOATS_PER_VECTOR, GL_FLOAT, GL_FALSE, BYTES_PER_ELEMENT,
                          Pointer.magic_cookie(BYTES_PER_VECTOR))

    glDrawElements(GL_TRIANGLES, @indices.count, GL_UNSIGNED_BYTE, Pointer.magic_cookie(0))

    glBindBuffer(GL_ARRAY_BUFFER, 0)
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0)
  end

  private
  def load_file
    File.open(@filePath) do |f|
      f.each_line.map(&:split).each do |line|
        case line.shift
        when 'v' then parse_point line
        when 'vn' then parse_normal line
        when 'f' then parse_face line
        end
      end
    end
  end

  def align_normals
    aligned_normals = Array.new @points.count
    visited = Array.new(@points.count) { false }

    @indices.zip(@normal_indices).each do |vi, ni|
      next if visited[vi]
      visited[vi] = true
      aligned_normals[vi] = @normals[ni]
    end

    @normals = aligned_normals
  end

  def pack_vertices
    @vertices = @points.zip(@normals).flatten
  end

  def load_opengl
    @vertexHandle = glGenBuffer
    glBindBuffer(GL_ARRAY_BUFFER, @vertexHandle)
    glBufferData(GL_ARRAY_BUFFER, @vertices.count * BYTES_PER_FLOAT,
                 to_ptr(:float, @vertices), GL_STATIC_DRAW)

    @indexHandle = glGenBuffer
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, @indexHandle)
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, @indices.count * BYTES_PER_INT,
                 to_ptr(:uchar, @indices), GL_STATIC_DRAW)
  end

  def parse_point line
    @points << line.map(&:to_f)
  end

  def parse_normal line
    @normals << line.map(&:to_f)
  end

  def parse_face line
    line.each do |c|
      i = c.split('/')
      @indices << i.first.to_i - 1
      @normal_indices << i.last.to_i - 1
    end
  end
end
