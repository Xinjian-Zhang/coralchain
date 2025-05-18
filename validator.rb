class Validator
  def self.verify(chain)
    results = []

    chain.each_cons(2) do |prev, current|
      valid = current.valid?(prev)
      results << {
        index: current.index,
        valid: valid,
        reason: valid ? "Valid" : detect_issue(prev, current)
      }
    end
    results
  end

  def self.detect_issue(prev, current)
    return "Broken hash link" unless current.previous_hash == prev.hash
    return "Hash mismatch" unless current.hash == current.calculate_hash
    return "Index discontinuity" unless current.index == prev.index + 1
    "Unknown error"
  end
end