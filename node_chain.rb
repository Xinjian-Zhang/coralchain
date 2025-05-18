require_relative 'block'
require_relative 'consensus'
require 'json'

class NodeChain
  attr_reader :chain, :id

  DATA_DIR = 'data/nodes'

  def initialize(id)
    raise "Invalid Node ID" unless id =~ /^[A-Z]$/
    @id = id
    @file_path = "#{DATA_DIR}/node_#{id}.json"
    @chain = load_chain
    @chain = [Block.create_genesis_block] if @chain.empty?
  end

  def latest_block
    @chain.last
  end

  def add_block(data, consensus_method = :pow)
    index = @chain.size
    previous_hash = latest_block.hash
    timestamp = Time.now.to_s

    nonce, hash, _ = Consensus.mine_block(index, timestamp, data, previous_hash, consensus_method)
    block = Block.new(index, timestamp, data, previous_hash, nonce, hash)

    @chain << block
    save_chain
  end

  def valid_chain?
    @chain.each_cons(2).all? { |prev, current| current.valid?(prev) }
  end

  def replace_if_longer(new_chain)
    return unless new_chain.length > @chain.length && valid_external_chain?(new_chain)

    @chain = new_chain
    save_chain
  end

  def valid_external_chain?(external)
    external.each_cons(2).all? { |prev, curr| curr.valid?(prev) }
  end

  def save_chain
    File.write(@file_path, JSON.pretty_generate(@chain.map(&:to_h)))
  rescue => e
    warn "❗ Failed to save chain for node #{@id}: #{e.message}"
  end

  def load_chain
    return [] unless File.exist?(@file_path)

    data = JSON.parse(File.read(@file_path))
    data.map { |block_data| Block.from_h(block_data) }.compact
  rescue => e
    warn "❗ Failed to load chain for node #{@id}: #{e.message}"
    []
  end

  def self.generate_fake_chain(length = 5)
    fake_chain = []
    prev_hash = "FAKEGENESIS"

    length.times do |i|
      block = Block.new(i, Time.now.to_s, "🧠 FAKE DATA #{i}", prev_hash, 0)
      prev_hash = block.hash
      fake_chain << block
    end

    file_path = "#{DATA_DIR}/node_X.json"
    File.write(file_path, JSON.pretty_generate(fake_chain.map(&:to_h)))
  rescue => e
    warn "❗ Failed to generate fake chain: #{e.message}"
  end

  def self.compare_chains(chain_a, chain_b)
    return :b if chain_a.empty?
    return :a if chain_b.empty?
  
    valid_a = Validator.verify(chain_a).all? { |r| r[:valid] }
    valid_b = Validator.verify(chain_b).all? { |r| r[:valid] }
  
    if valid_a && valid_b
      return :a if chain_a.length > chain_b.length
      return :b if chain_b.length > chain_a.length
    elsif valid_a
      return :a
    elsif valid_b
      return :b
    end
    :equal
  end
end