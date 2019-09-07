def get_jobs_done(s)
  my_hash = set_hash(s)
  res = []
  state = []

  my_hash.each do |key, value|
    finish_job(key, [value], my_hash, res, true, state)
  end

  state.size > 0 ? state[0] : res.join(',')
end

def finish_job(key, values, my_hash, res, first, state)
  return if state.size > 0

  if my_hash[key].nil?
    state << "Error: Jobs can't have non-existant dependencies."
    return
  end

  if my_hash[key] == key
    state << "Error: Jobs can't depend on themselves."
    return
  end

  if !first and values.include? my_hash[key]
    state << "Error: Jobs can't have circular dependencies."
    return
  end

  unless my_hash[key]
    add_to_res(key, res)
    return
  end

  values << my_hash[key]
  finish_job(my_hash[key], values, my_hash, res, false, state)
  add_to_res(key, res)
end

def add_to_res(key, res)
  res << key unless res.include? key
end

def set_hash(s)
  my_jobs = s.split("\n")
  my_hash = Hash.new

  my_jobs.each do |j|
    val = j.split('=>')
    return false unless my_hash[val[0]].nil?
    my_hash[val[0]] = val[1] || false
  end

  return my_hash
end