require 'json'

class GraphTheory

  attr_accessor :vertexes

  def initialize
    self.vertexes = []
  end

  def create_vertex name, value
    vertexes_validation_uniqueness value
    vertexes << {name: name, value: value, edges: []}
    ({status: 201, vertexes: vertexes})
  rescue => e
    ({status: 401, message: e.message})
  end

  def create_edge name, from, to
    vertexes_validation_present to
    vs = vertexes.map{|el| el.dup}
    vs.map! do |el|
      if el[:value] == from
        if el[:value] != to
          if el[:edges].count <= 1
            if not el[:edges].map{|el| el[:value]}.include? to
              el.merge({edges: el[:edges].dup << {value: to, name: name} })
            else
              raise 'Vertex has already had the same edge'
            end
          else
            raise 'Vertex has already had two edges'
          end
        else
          raise 'Edge shouldn\'t have the same value as vertex'
        end
      else
        el
      end
    end

    edges_validation_uniqueness vs, from
    self.vertexes = vs
  rescue => e
    ({status: 401, message: e.message})
  end

  def vertexes_validation_uniqueness value
    raise "Graph has already had the vertex: #{value}" if vertexes.any? do |vertex|
      vertex[:value] == value
    end
  end

  def vertexes_validation_present value
    raise "Graph has not had the vertex: #{value}" unless vertexes.any? do |vertex|
      vertex[:value] == value
    end
  end

  def edges_validation_uniqueness vertexes, from
    red_vertexes = []
    es = [from]

    while es.any? do
      new_edges = []
      es.each do |el|
        new_edges.push *vertexes.find {|v| v[:value] == el }&.dig(:edges)&.map{|el| el[:value]}
        red_vertexes.push *new_edges
        unless red_vertexes.uniq.length == red_vertexes.length
          es = []
          raise "Validator has find a cycle. Please choose an other vertexes"
        end
      end
      es = new_edges
    end

  end

end