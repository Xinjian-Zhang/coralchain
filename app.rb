require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'csv'
require 'benchmark'
require_relative 'blockchain'
require_relative 'node_chain'
require_relative 'consensus'
require_relative 'validator'
require_relative 'chain_diff'

blockchain = Blockchain.new

helpers do
  def valid_node_id?(id)
    %w[A B X].include?(id)
  end

  def load_node(id)
    halt 400, "Invalid node ID" unless valid_node_id?(id)
    NodeChain.new(id)
  end

  def run_trials(trials, method, difficulty = 2)
    (0...trials).map do |i|
      index = i
      timestamp = Time.now.to_s
      data = "#{method.upcase} Block #{i}"
      prev_hash = "0" * 64
      _, _, duration = Consensus.mine_block(index, timestamp, data, prev_hash, method, difficulty)
      (duration * 1000).round(2)
    end
  end
end

get '/' do
  @chain = blockchain.chain
  erb :index
end

get '/add' do
  erb :add
end

post '/add' do
  data = params[:data]
  method = params[:consensus].to_sym
  blockchain.add_block(data, method)
  redirect '/'
end

get '/verify' do
  @chain = blockchain.chain
  @results = Validator.verify(@chain)
  erb :verify
end

get '/simulate' do
  erb :simulate
end

post '/simulate/result' do
  trials = [params[:trials].to_i, 1].max
  @trial_count = trials
  @series = %i[pow poa pos].map do |method|
    [method.to_s.upcase, run_trials(trials, method)]
  end.to_h

  erb :simulate_result
end

get '/nodes' do
  @node_a = load_node("A")
  @node_b = load_node("B")
  @diff = ChainDiff.diff(@node_a.chain, @node_b.chain)
  erb :nodes
end

post '/nodes/sync' do
  node_a = load_node("A")
  node_b = load_node("B")
  if node_a.chain.length >= node_b.chain.length
    node_b.replace_if_longer(node_a.chain)
    redirect '/nodes?synced=AtoB'
  else
    node_a.replace_if_longer(node_b.chain)
    redirect '/nodes?synced=BtoA'
  end
end

get '/nodes/add/:id' do
  @id = params[:id]
  halt 400 unless valid_node_id?(@id)
  erb :add_node_block
end

post '/nodes/add/:id' do
  id = params[:id]
  halt 400 unless valid_node_id?(id)
  data = params[:data]
  method = params[:consensus].to_sym
  load_node(id).add_block(data, method)
  redirect '/nodes'
end

post '/nodes/fork' do
  node_a = load_node("A")
  node_b = load_node("B")

  node_a.add_block("Fork A1", :poa)
  node_b.add_block("Fork B1", :poa)
  node_b.add_block("Fork B2", :poa)

  redirect '/nodes?forked=1'
end

get '/attack' do
  @node_id = params[:node]
  @node = load_node(@node_id)
  erb :attack
end

post '/attack' do
  node_id = params[:node]
  index = params[:index].to_i
  new_data = params[:data]

  node = load_node(node_id)
  if block = node.chain[index]
    block.instance_variable_set(:@data, new_data)
    block.instance_variable_set(:@hash, "HACKED_HASH_#{rand(1000..9999)}")
    node.save_chain
  end
  redirect '/nodes?tampered=1'
end

get '/attack/fake_chain' do
  NodeChain.generate_fake_chain(6)
  redirect '/nodes?fake=1'
end

post '/nodes/sync_x' do
  target = params[:target]
  node_x = load_node("X")
  target_node = load_node(target)

  if node_x.chain.length > target_node.chain.length && node_x.valid_chain?
    target_node.replace_if_longer(node_x.chain)
    redirect "/nodes?synced=Xto#{target}"
  else
    redirect "/nodes?rejected=1"
  end
end

get '/export/:id.csv' do
  node = load_node(params[:id])
  content_type 'text/csv'
  attachment "coralchain_node_#{node.id}.csv"

  CSV.generate do |csv|
    csv << %w[Index Timestamp Data PrevHash Hash Nonce]
    node.chain.each { |b| csv << [b.index, b.timestamp, b.data, b.previous_hash, b.hash, b.nonce] }
  end
end

get '/export/:id.md' do
  node = load_node(params[:id])
  @md = "# CoralChain Node #{node.id} Report\n\n"
  node.chain.each do |block|
    @md += "## Block #{block.index}\n"
    @md += "- **Timestamp:** #{block.timestamp}\n"
    @md += "- **Data:** #{block.data}\n"
    @md += "- **Previous Hash:** `#{block.previous_hash}`\n"
    @md += "- **Hash:** `#{block.hash}`\n"
    @md += "- **Nonce:** #{block.nonce}\n\n"
  end
  erb :export_md
end

get '/experiment' do
  erb :experiment
end

post '/experiment/result' do
  trials = params[:trials].to_i
  difficulties = params[:difficulties].split(',').map(&:to_i)

  @trials = trials
  @results = difficulties.map do |diff|
    times = run_trials(trials, :pow, diff)
    { difficulty: diff, times: times, avg: (times.sum / times.size).round(2) }
  end
  erb :experiment_result
end

post '/experiment/export_csv' do
  trials = params[:trials].to_i
  difficulties = params[:difficulties].split(',').map(&:to_i)

  content_type 'text/csv'
  attachment "experiment_results.csv"

  CSV.generate do |csv|
    csv << ["Difficulty", "Trial Times (ms)", "Average", "Min", "Max"]
    difficulties.each do |diff|
      times = run_trials(trials, :pow, diff)
      avg = (times.sum / times.size).round(2)
      csv << [diff, times.join(" "), avg, times.min, times.max]
    end
  end
end

get '/compare_consensus' do
  erb :compare_consensus
end

post '/compare_consensus/result' do
  trials = params[:trials].to_i
  mechanisms = %i[pow poa pos]

  @trials = trials
  @results = mechanisms.map do |method|
    times = run_trials(trials, method)
    avg = (times.sum / times.size).round(2)
    stddev = Math.sqrt(times.map { |t| (t - avg) ** 2 }.sum / times.size).round(2)

    {
      method: method,
      times: times,
      avg: avg,
      min: times.min,
      max: times.max,
      stddev: stddev
    }
  end

  erb :compare_consensus_result
end

post '/compare_consensus/export_csv' do
  trials = params[:trials].to_i
  mechanisms = %i[pow poa pos]

  content_type 'text/csv'
  attachment "consensus_comparison.csv"

  CSV.generate do |csv|
    csv << ["Mechanism", "Trial Times (ms)", "Average", "Min", "Max", "Std Dev"]
    mechanisms.each do |method|
      times = run_trials(trials, method)
      avg = (times.sum / times.size).round(2)
      stddev = Math.sqrt(times.map { |t| (t - avg) ** 2 }.sum / times.size).round(2)
      csv << [method.to_s.upcase, times.join(", "), avg, times.min, times.max, stddev]
    end
  end
end

get '/' do
  @chain = blockchain.chain
  erb :index
end

get '/gossip' do
  erb :gossip
end

get '/fork' do
  erb :fork
end

post '/compare_benchmark/export_csv' do
  trials = params[:trial_count].to_i
  mechanisms = %w[POW POA POS]

  results = mechanisms.map do |method|
    times = run_trials(trials, method.downcase.to_sym)
    {
      method: method,
      times: times,
      avg: (times.sum / times.size.to_f).round(2),
      min: times.min,
      max: times.max
    }
  end

  content_type 'text/csv'
  attachment "benchmark_results_#{Time.now.strftime('%Y%m%d')}.csv"

  CSV.generate do |csv|
    csv << ['Trial'] + mechanisms
    (0...trials).each do |i|
      row = [i + 1]
      results.each { |r| row << r[:times][i] }
      csv << row
    end

    csv << []
    csv << ['Summary']
    results.each do |r|
      csv << [r[:method], "Avg: #{r[:avg]}", "Min: #{r[:min]}", "Max: #{r[:max]}"]
    end
  end
end

post '/experiment/export_csv' do
  trials = params[:trials].to_i
  difficulties = params[:difficulties].split(',').map(&:to_i)
  results = difficulties.map do |diff|
    times = run_trials_per_difficulty(trials, diff)
    {
      difficulty: diff,
      times: times,
      avg: (times.sum / times.size.to_f).round(2),
      min: times.min,
      max: times.max
    }
  end

  content_type 'text/csv'
  attachment "pow_difficulty_experiment_#{Time.now.strftime('%Y%m%d')}.csv"

  CSV.generate do |csv|
    csv << ['Trial'] + difficulties.map { |d| "Difficulty #{d}" }
    (0...trials).each do |i|
      row = [i + 1]
      results.each { |r| row << r[:times][i] }
      csv << row
    end

    csv << []
    csv << ['Summary']
    results.each do |r|
      csv << ["Difficulty #{r[:difficulty]}", "Avg: #{r[:avg]}", "Min: #{r[:min]}", "Max: #{r[:max]}"]
    end
  end
end
