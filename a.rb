require './unit_disk_graph'
require './vertex'

u = UnitDiskGraph.new
u.add_vertex(Vertex.new(1, 2))
u.add_vertex(Vertex.new(1, 3))
u.add_vertex(Vertex.new(2, 2))
u.add_vertex(Vertex.new(2, 3))
u.add_vertex(Vertex.new(1, 2.5))
u.add_vertex(Vertex.new(1.5, 2.5))
puts u.color
