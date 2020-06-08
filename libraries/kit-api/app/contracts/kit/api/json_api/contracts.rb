# Contracts for the project
module Kit::Api::JsonApi::Contracts

  include Kit::Api::Contracts

  Document = Hash[
    cache:    Hash.named('Document[:cache]'),
    included: Hash.named('Document[:included]'),
    response: Hash[
      data:     Or[Array, Hash],
      included: Array,
    ].named('Document[:response]'),
  ].named('Document')

end
