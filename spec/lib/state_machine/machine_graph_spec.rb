require 'state_machine/machine_graph'
require 'support/fancy_machine'

RSpec.describe StateMachine::MachineGraph do
  let(:file_path) { File.join(Dir.pwd, 'spec', 'FancyMachine.png') }
  let(:graph) { described_class.new(FancyMachine, path: File.dirname(file_path)) }

  it 'creates file' do
    FileUtils.rm(file_path) if File.exist?(file_path)
    graph.draw
    expect(File).to exist(file_path)
  end

  it 'creates nodes for each state' do
    graph.draw
    expect(graph.send(:nodes).keys).to eq(%i[standing walking running])
  end
end
