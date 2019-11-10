require_relative 'rails_helper'
require_relative '../lib/kit/contract'

module TestClasses
  module RGB
    include Kit::Contract

    before ->(r:, g:, b:) { (0..255) === r && (0..255) === g && (0..255) === b }
    after  [
      ->(result) { result.is_a?(String) },
      ->(result) { result.start_with?('#') },
      ->(result) do
        if result.start_with?('#')
          [:ok]
        else
          [:error, "The result should start with a `#` sign"]
        end
      end,
      ->(result) { result.length.in?([4, 7]) },
    ]
    def self.rgb_to_hex(r:, g:, b:)
      "#" << [r, g, b].map { |el| el.to_s(16).rjust(2, '0') }.join.upcase
    end

  end
end


describe "RGB" do

  context 'with valid values' do
    let(:subject) { TestClasses::RGB.method(:rgb_to_hex) }

    let(:args_valid) do
      {
        [{ r: 128, g: 32, b: 12, }] => '#80200C',
      }
    end

    it 'succeeds' do
      args_valid.each do |args_in, args_out|
        expect(subject.call(*args_in)).to eq args_out
      end
    end
  end

end