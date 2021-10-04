require 'kit/doc'

require_relative '../../spec_helper'

describe Kit::Doc::Services::MarkdownPreprocessor do
  let(:service) { described_class }

  describe '.preproc_variables' do
    let(:input_text)  { '.$version_display. _$VERSION_DISPLAY_$v2$ $version_2 \$version' }
    let(:output_text) { '.a1. _a2a3$ a4 \$version' }
    let(:variables) do
      {
        version_display:  'a1',
        VERSION_DISPLAY_: 'a2',
        v2:               'a3',
        version_2:        'a4',
        version:          'a5',
      }
    end

    let(:subject) do
      service.preproc_variables(
        text:      input_text,
        variables: variables,
      )
    end

    it 'generate the correct string' do
      expect(subject[1][:processed_text]).to eq output_text
    end

  end

  context '.preproc_conditionals' do

    spec_values = [
      {
        before: <<~DATA,
          # Before
          <!--pp { [KitDoc link](https://github.com/rubykit/kit/blob/$VERSION/libraries/kit-doc) } -->
          [GitHub link](https://github.com/rubykit/kit/tree/main/libraries/kit-doc)
          <!-- pp-->
          # After
        DATA
        after:  <<~DATA,
          # Before
          [KitDoc link](https://github.com/rubykit/kit/blob/v0.1.0/libraries/kit-doc)
          # After
        DATA
      },
      {
        before: <<~DATA,
          # Before
          <!--pp {
          [KitDoc link](https://github.com/rubykit/kit/blob/$VERSION/libraries/kit-doc)
          } -->
          [GitHub link](https://github.com/rubykit/kit/tree/main/libraries/kit-doc)
          <!-- pp-->
          # After
        DATA
        after:  <<~DATA,
          # Before
          [KitDoc link](https://github.com/rubykit/kit/blob/v0.1.0/libraries/kit-doc)
          # After
        DATA
      },
      {
        before: <<~DATA,
          <!--pp { [KitDoc link](https://github.com/rubykit/kit/blob/$VERSION/libraries/kit-doc) \} } pp-->
        DATA
        after:  <<~DATA,
          [KitDoc link](https://github.com/rubykit/kit/blob/v0.1.0/libraries/kit-doc)
        DATA
      },
      {
        before: <<~DATA,
          <!--pp {
          [KitDoc link](https://github.com/rubykit/kit/blob/$VERSION/libraries/kit-doc) \} }
          } pp-->
        DATA
        after:  <<~DATA,
          [KitDoc link](https://github.com/rubykit/kit/blob/v0.1.0/libraries/kit-doc)
        DATA
      },
    ]

    let(:variables) do
      {
        VERSION: 'v0.1.0',
      }
    end

    spec_values.each_as_kwargs do |before:, after:|
      it 'preprocesses the text correctly' do
        _status, ctx = service.preproc_conditionals(
          text:      before,
          variables: variables,
        )

        expect(ctx[:processed_text]).to eq(after)
      end
    end

  end

end
