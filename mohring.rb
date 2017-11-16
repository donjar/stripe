# frozen_string_literal: true

require './next_flow'
require 'set'

module Mohring
  extend self

  def optimise(coloring)
    @coloring = coloring
    @adjacency_list = {}
    @vertices = coloring.keys

    construct_network
    construct_flow
    ford_fulkerson
    construct_color
  end

  def construct_network
    @vertices.each do |vertex|
      # Connect my out -> other's in
      @adjacency_list["#{vertex}-out"] = @vertices.inject({}) do |accum, curr|
        # Don't connect if:
        # - curr is lower than vertex in terms of y coordinates
        # - distance <= 1
        next accum if curr.y <= vertex.y || curr.distance_to(vertex) <= 1
        accum.tap { |a| a["#{curr}-in"] = NextFlow.new(amount: 0, bound: 0) }
      end

      # Connect my out -> sink
      @adjacency_list["#{vertex}-out"]['sink'] =
        NextFlow.new(amount: 0, bound: 0)

      # Connect in -> out
      @adjacency_list["#{vertex}-in"] =
        { "#{vertex}-out" => NextFlow.new(amount: 0, bound: 1) }
    end

    # Connect source -> in
    @adjacency_list['source'] = @vertices.map do |vertex|
      ["#{vertex}-in", NextFlow.new(amount: 0, bound: 0)]
    end.to_h
  end

  def construct_flow
    colors = @coloring.values.uniq

    colors.each do |color|
      color_vertices = @coloring.inject([]) do |accum, curr|
        next accum if curr[1] != color
        accum << curr[0]
      end
      color_vertices.sort_by!(&:y)

      # Add flow from v_in -> v_out
      color_vertices.each do |v|
        @adjacency_list["#{v}-in"]["#{v}-out"].amount += 1
      end

      # Add flow from before_out -> after_in
      color_vertices.each_cons(2) do |v1, v2|
        @adjacency_list["#{v1}-out"]["#{v2}-in"].amount += 1
      end

      # Source and sink flows
      @adjacency_list['source']["#{color_vertices.first}-in"].amount += 1
      @adjacency_list["#{color_vertices.last}-out"]['sink'].amount += 1
    end
  end

  def ford_fulkerson
    loop do
      stack = [['source']]
      visited = Set.new

      loop do
        return if stack.empty?
        path = stack.pop
        v = path.last
        visited.add(v)

        if v == 'sink'
          decrease_flow(path)
          break
        end

        neighbors = @adjacency_list[v]

        neighbors.each do |n, f|
          if f.overloaded? && !visited.include?(n)
            stack.push(Array.new(path) << n)
          end
        end
      end
    end
  end

  def construct_color
    coloring = {}
    color_number = 0

    loop do
      stack = [['source']]
      visited = Set.new

      loop do
        return coloring if stack.empty?
        path = stack.pop
        v = path.last
        visited.add(v)

        if v == 'sink'
          decrease_flow(path)
          path.each do |path_vertex|
            coloring[path_vertex] = color_number
          end

          color_number += 1
          break
        end

        neighbors = @adjacency_list[v]

        neighbors.each do |n, f|
          if f.amount > 0 && !visited.include?(n)
            stack.push(Array.new(path) << n)
          end
        end
      end
    end
  end

  def decrease_flow(path)
    path.each_cons(2) { |v1, v2| @adjacency_list[v1][v2].amount -= 1 }
  end
end
