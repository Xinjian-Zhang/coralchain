class Block
  attr_reader :index, :timestamp, :data, :previous_hash, :nonce, :hash, :signature

  def initialize(index, timestamp, data, previous_hash, nonce = 0, hash = nil, signature = nil)
    @index = index
    @timestamp = timestamp
    @data = data
    @previous_hash = previous_hash
    @nonce = nonce
    @hash = hash || calculate_hash
    @signature = signature || generate_signature
  end

  def calculate_hash
    Digest::SHA256.hexdigest("#{@index}#{@timestamp}#{@data}#{@previous_hash}#{@nonce}")
  end

  def generate_signature
    Digest::SHA256.hexdigest("#{@data}#{@nonce}")
  end

  def verify_signature
    @signature == Digest::SHA256.hexdigest("#{@data}#{@nonce}")
  end

  def valid?(previous_block)
    return false unless previous_block
    return false unless @previous_hash == previous_block.hash
    return false unless @hash == calculate_hash
    return false unless @index == previous_block.index + 1
    return false unless verify_signature
    true
  end

  def self.create_genesis_block
    Block.new(0, Time.now.to_s, "Genesis Block", "0")
  end

  def to_h
    {
      index: @index,
      timestamp: @timestamp,
      data: @data,
      previous_hash: @previous_hash,
      nonce: @nonce,
      hash: @hash,
      signature: @signature
    }
  end

  def self.from_h(hash)
    required_keys = %w[index timestamp data previous_hash nonce hash signature]
    return nil unless required_keys.all? { |k| hash.key?(k) }

    Block.new(
      hash["index"],
      hash["timestamp"],
      hash["data"],
      hash["previous_hash"],
      hash["nonce"],
      hash["hash"],
      hash["signature"]
    )
  end
end
