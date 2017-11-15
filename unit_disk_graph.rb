# frozen_string_literal: true

class UnitDiskGraph
  attr_reader :adjacency_list

  def initialize(radius = 1)
    @radius = radius
    @adjacency_list = {}
  end

  def add_vertex(vertex)
    return if @adjacency_list.keys.any? { |v| v == vertex }

    @adjacency_list.each do |v, neighbors|
      neighbors << vertex if v.distance_to(vertex) <= @radius
    end

    @adjacency_list[vertex] = @adjacency_list.keys.select do |v|
      v.distance_to(vertex) <= @radius
    end
  end

  def delete_vertex(vertex)
    @adjacency_list[vertex].each { |n| @adjacency_list[n].delete(vertex) }
    @adjacency_list.delete(vertex)
  end

  def stripe_partition(width)
    x_coords = vertices.map(&:x)
    min_x = x_coords.min
    max_x = x_coords.max

    Array.new(((max_x - min_x) / width + 1).floor) { [] }.tap do |vertex_groups|
      vertices.each do |v|
        pos = ((v.x - min_x) / width).floor
        vertex_groups[pos] << v
      end
    end
  end

  def color
    min_coloring = nil
    vertices.permutation.each do |permutation|
      coloring = {}

      permutation.each do |vertex|
        filled = Array.new(vertices.length, false)
        @adjacency_list[vertex].each do |neighbor|
          next unless coloring.include?(neighbor)
          filled[coloring[neighbor]] = true
        end

        coloring[vertex] = filled.index(false)
      end

      if min_coloring.nil? || coloring.values.max < min_coloring.values.max
        min_coloring = coloring
      end
    end

    min_coloring
  end

  private def vertices
    @adjacency_list.keys
  end
end
