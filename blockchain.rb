require_relative 'block'
require_relative 'consensus'
require 'json'

class Blockchain
  attr_reader :chain

  FILE_PATH = 'data/chain.json'

  def initialize
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
  
    difficulty = 4
    if consensus_method == :pow
      nonce, hash, duration = Consensus.mine_block(index, timestamp, data, previous_hash, consensus_method, difficulty)
    else
      nonce, hash, duration = Consensus.mine_block(index, timestamp, data, previous_hash, consensus_method)
    end
  
    # Log for debugging
    puts "=== Mining result ==="
    puts "Nonce: #{nonce}"
    puts "Hash: #{hash} (class: #{hash.class})"
    puts "Duration: #{duration.round(2)}s"
  
    block = Block.new(index, timestamp, data, previous_hash, nonce, hash)
  
    puts "Block hash from object: #{block.hash}"
    puts "Recalculated hash: #{block.calculate_hash}"
    puts "Block valid? #{block.valid?(latest_block) ? '✅' : '❌'}"
    puts "===================="
  
    @chain << block
    save_chain
  end
  

  def valid_chain?
    @chain.each_cons(2).all? { |prev, current| current.valid?(prev) }
  end

  def save_chain
    File.write(FILE_PATH, JSON.pretty_generate(@chain.map(&:to_h)))
  rescue => e
    warn "❗ Failed to save chain: #{e.message}"
  end

  def load_chain
    return [] unless File.exist?(FILE_PATH)

    data = JSON.parse(File.read(FILE_PATH))
    data.map { |block_data| Block.from_h(block_data) }.compact
  rescue => e
    warn "❗ Failed to load chain: #{e.message}"
    []
  end
end
