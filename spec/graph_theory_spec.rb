require "./graph_theory"

describe GraphTheory do
  describe ".create_vertex" do

    context "vertexes tests" do

      it "should add new vertexes" do
        graph_theory = GraphTheory.new
        expect(graph_theory.create_vertex 'first', 1).to eq({:status=>201, :vertexes=>[{:name=>"first", :value=>1, :edges=>[]}]})
        expect(graph_theory.create_vertex 'second', 2).to eq({:status=>201, :vertexes=>[
            {:name=>"first", :value=>1, :edges=>[]},
            {:name=>"second", :value=>2, :edges=>[]}
        ]})

      end

      it "should't have a second vertex with the same value" do
        graph_theory = GraphTheory.new
        expect(graph_theory.create_vertex 'first', 1).to eq({:status=>201, :vertexes=>[{:name=>"first", :value=>1, :edges=>[]}]})
        expect(graph_theory.create_vertex 'second', 1).to eq({:status=>401, :message=>"Graph has already had the vertex: 1"})
      end

    end

    context "edges tests" do
      it "should add new edges" do
        graph_theory = GraphTheory.new
        expect(graph_theory.create_vertex 'first vertex', 1)
        expect(graph_theory.create_vertex 'second vertex', 2)
        expect(graph_theory.create_vertex 'third vertex', 3)

        expect((graph_theory.create_edge 'first edge', 1, 2).first).to eq(
            {:name=>"first vertex", :value=>1, :edges=>[{value: 2, name: 'first edge'}]}
        )
        expect((graph_theory.create_edge 'second vertex', 2, 3)[1..2]).to eq([
           {:name=>"second vertex", :value=>2, :edges=>[{:value=>3, :name=>"second vertex"}]},
           {:name=>"third vertex", :value=>3, :edges=>[]}
        ])
      end

      it "shouldn't have the same value as vertex" do
        graph_theory = GraphTheory.new
        expect(graph_theory.create_vertex 'first vertex', 1)
        expect(graph_theory.create_vertex 'second vertex', 2)
        expect(graph_theory.create_vertex 'third vertex', 3)

        expect((graph_theory.create_edge 'first edge', 1, 2).first).to eq(
           {:name=>"first vertex", :value=>1, :edges=>[{:value=>2, :name=>"first edge"}]}
        )
        expect(graph_theory.create_edge 'second edge', 1, 2).to eq(
                                                                      {
                                                                          :status=>401,
                                                                          :message=>"Vertex has already had the same edge"
                                                                      }
                                                                  )
      end

      it "shouldn't have more than two edges" do
        graph_theory = GraphTheory.new
        expect(graph_theory.create_vertex 'first vertex', 1)
        expect(graph_theory.create_vertex 'second vertex', 2)
        expect(graph_theory.create_vertex 'third vertex', 3)
        expect(graph_theory.create_vertex 'fourth vertex', 4)

        expect((graph_theory.create_edge 'first edge', 1, 2).first).to eq(
            {:name=>"first vertex", :value=>1, :edges=>[{:value=>2, :name=>"first edge"}]}
        )

        expect((graph_theory.create_edge 'second edge', 1, 3).first).to eq(
            {:name=>"first vertex", :value=>1, :edges=>[{:value=>2, :name=>"first edge"}, {:value=>3, :name=>"second edge"}]}
        )

        expect(graph_theory.create_edge 'third edge', 1, 4).to eq({:status=>401, :message=>"Vertex has already had two edges"})
      end

      it "shouldn't have the same edge" do
        graph_theory = GraphTheory.new
        expect(graph_theory.create_vertex 'first vertex', 1)
        expect(graph_theory.create_vertex 'second vertex', 2)


        expect((graph_theory.create_edge 'first edge', 1, 2).first).to eq(
            {:name=>"first vertex", :value=>1, :edges=>[{:value=>2, :name=>"first edge"}]}
        )

        expect(graph_theory.create_edge 'second vertex', 1, 2).to eq({:status=>401, :message=>"Vertex has already had the same edge"})
      end

      it "shouldn't have more than two edges" do
        graph_theory = GraphTheory.new
        expect(graph_theory.create_vertex 'first vertex', 1)
        expect(graph_theory.create_vertex 'second vertex', 2)
        expect(graph_theory.create_vertex 'third vertex', 3)
        expect(graph_theory.create_vertex 'fourth vertex', 4)

        expect((graph_theory.create_edge 'first edge', 1, 2).first).to eq(
          {:name=>"first vertex", :value=>1, :edges=>[{:value=>2, :name=>"first edge"}]}
        )

        expect((graph_theory.create_edge 'second edge', 1, 3).first).to eq(
            {:name=>"first vertex", :value=>1, :edges=>[{:value=>2, :name=>"first edge"}, {:value=>3, :name=>"second edge"}]}
        )

        expect(graph_theory.create_edge 'third edge', 1, 4).to eq({:status=>401, :message=>"Vertex has already had two edges"})
      end

      it "shouldn't have a cycle" do
        graph_theory = GraphTheory.new
        expect(graph_theory.create_vertex 'first vertex', 1)
        expect(graph_theory.create_vertex 'second vertex', 2)
        expect(graph_theory.create_vertex 'third vertex', 3)

        expect((graph_theory.create_edge 'first edge', 1, 2).first).to eq(
            {:name=>"first vertex", :value=>1, :edges=>[{:value=>2, :name=>"first edge"}]}
        )

        expect((graph_theory.create_edge 'second edge', 2, 3)[1]).to eq(
             {:name=>"second vertex", :value=>2, :edges=>[{:value=>3, :name=>"second edge"}]}
        )

        expect(graph_theory.create_edge 'third edge', 3, 1).to eq(
            {:status=>401, :message=>"Validator has find a cycle. Please choose an other vertexes"}
        )
      end

    end

  end
end