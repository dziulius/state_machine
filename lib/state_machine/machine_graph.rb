require 'graphviz'

module StateMachine
  # Generates state machine graph using GraphViz
  class MachineGraph
    # :reek:ControlParameter
    def initialize(klass, path: nil)
      self.file_name = File.join(path || Dir.pwd, "#{klass}.png")
      self.machine = klass.machine
      self.nodes = {}
      self.graph = GraphViz.new(:G, type: :digraph)
    end

    def draw
      add_nodes
      add_initial_state
      add_edges

      graph.output(png: file_name)
    end

    private

    def add_nodes
      machine.states.each_key do |state|
        nodes[state] = graph.add_nodes(state.to_s)
      end
    end

    def add_initial_state
      initial = machine.initial_state
      return unless initial

      point = graph.add_nodes('initial_state', shape: 'point')

      graph.add_edges(point, nodes[initial])
    end

    def add_edges
      machine.events.each_value do |event|
        add_event_edges(event)
      end
    end

    # :reek:NestedIterators
    def add_event_edges(event)
      event.available_transitions.each do |transition|
        transition.from.each do |from|
          graph.add_edges(nodes[from], nodes[transition.to], label: event.name.to_s)
        end
      end
    end

    attr_accessor :file_name, :machine, :nodes, :graph
  end
end
