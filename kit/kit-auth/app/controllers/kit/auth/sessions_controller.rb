# frozen_string_literal: true

module Kit
  module Auth
    class SessionsController < ApplicationController # :nodoc:

      def index
        render(
          json: { test: 1 },
          status: :ok
        )
      end

    end
  end
end