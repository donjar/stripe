require './unit_disk_graph'
require './vertex'

u = UnitDiskGraph.new(10)
u.add_vertex(Vertex.new(10, 20))
u.add_vertex(Vertex.new(10, 30))
u.add_vertex(Vertex.new(12, 20))
u.add_vertex(Vertex.new(12, 30))
u.add_vertex(Vertex.new(10, 25))
u.add_vertex(Vertex.new(15, 25))
u.add_vertex(Vertex.new(13, 35))
u.add_vertex(Vertex.new(11, 45))
u.add_vertex(Vertex.new(15, 35))
u.add_vertex(Vertex.new(11, 30))
u.add_vertex(Vertex.new(11, 35))
puts u.lexicographic_color
puts u.mohring_color
