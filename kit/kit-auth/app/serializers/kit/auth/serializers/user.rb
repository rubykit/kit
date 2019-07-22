require 'fast_jsonapi'

module Kit::Auth::Serializers
  class User #:nodoc:
    include FastJsonapi::ObjectSerializer

    attributes(
      :email,
      :created_at,
    )
  end
end