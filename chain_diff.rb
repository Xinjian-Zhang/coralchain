class ChainDiff
    def self.diff(chain_a, chain_b)
      max_len = [chain_a.length, chain_b.length].max
      diffs = []
  
      max_len.times do |i|
        block_a = chain_a[i]
        block_b = chain_b[i]
  
        if block_a.nil? || block_b.nil?
          diffs << :mismatch
        elsif block_a.hash != block_b.hash
          diffs << :mismatch
        else
          diffs << :match
        end
      end
      diffs
    end
  end