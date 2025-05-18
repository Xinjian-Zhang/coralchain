require 'digest'

module Consensus
  def self.calculate_hash(index, timestamp, data, previous_hash, nonce)
    Digest::SHA256.hexdigest("#{index}#{timestamp}#{data}#{previous_hash}#{nonce}")
  end

  # POW - Simulate the real mining process, till a hash that meets the difficulty is found
  def self.mine_pow(index, timestamp, data, previous_hash, difficulty = 5)
    nonce = 0
    prefix = "0" * difficulty
    start_time = Time.now
    hash = nil
  
    loop do
      hash = calculate_hash(index, timestamp, data, previous_hash, nonce)
      break if hash.start_with?(prefix)
      nonce += 1
    end
  
    duration = Time.now - start_time
    [nonce, hash, duration]
  end
  

  # POA -  Increase the number of rounds to simulate more work (keep the hash format unchanged)
  def self.mine_poa(index, timestamp, data, previous_hash, rounds = 95)
    start_time = Time.now
    nonce = 0
    hash = nil
    rounds.times do
      nonce = rand(1..10000)
      hash = calculate_hash(index, timestamp, data, previous_hash, nonce)
    end
    duration = Time.now - start_time
    [nonce, hash, duration]
  end

  # POS - Perform multiple hash calculations to simulate the amount of computation
  def self.mine_pos(index, timestamp, data, previous_hash, rounds = 125)
    start_time = Time.now
    nonce = 0
    hash = nil
    rounds.times do
      stake_weight = rand(1..100)
      nonce = stake_weight * rand(1..10)
      hash = calculate_hash(index, timestamp, data, previous_hash, nonce)
    end
    duration = Time.now - start_time
    [nonce, hash, duration]
  end

  # Unified the interface for diff consensus methods
  def self.mine_block(index, timestamp, data, previous_hash, method = :pow, difficulty = 6)
    case method
    when :pow
      mine_pow(index, timestamp, data, previous_hash, difficulty)
    when :poa
      mine_poa(index, timestamp, data, previous_hash)
    when :pos
      mine_pos(index, timestamp, data, previous_hash)
    else
      raise ArgumentError, "Unknown consensus method: #{method}"
    end
  end
end
