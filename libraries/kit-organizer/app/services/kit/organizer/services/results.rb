module Kit::Organizer::Services::Results
  include Kit::Contract
  Ct = Kit::Organizer::Contracts

  # TODO: add indications on how/what to deep merge
  contract Ct::Hash[results: Ct::Array.of(Ct::ResultTupple)]
  def self.merge(results:)
    status = results.map { |el| el[0] }.uniq

    if status.size == 1
      if status[0] == :error
        handle_error(results: results)
      else
        handle_ok(results: results)
      end
    else
      raise "ResultTupple can only be merged if they have the same status"
    end
  end

  def self.handle_ok(results:)
    res = {}

    results.each do |result|
      result[1].each do |k, v|
        if !res[k]
          res[k] = v
        elsif res[k] != v
          raise "Handle me"
        end
      end
    end

    [:ok, res]
  end

  def self.handle_error(results:)
    [:error, errors: results.map { |el| el[:errors] }.flatten]
  end

end