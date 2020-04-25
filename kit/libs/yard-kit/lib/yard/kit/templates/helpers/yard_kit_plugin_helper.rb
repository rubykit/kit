# frozen_string_literal: true
module Yard
  module Kit
    module Templates
      module Helpers

        module YardKitPluginHelper

          # Allow access to plugin config
          def config
            ::Yard::Kit::Config.config
          end

          # If a class if module is defined in several files, removes the one that are nested, as it is probably used as a namespace in that case.
          def cleanup_files(list:)
            list.reject do |cr_el_path, _cr_el_line|
              cr_el_path = cr_el_path[0..-4] if cr_el_path.end_with?('.rb')

              status = false
              list.each do |el_path, _el_line|
                el_path = el_path[0..-4] if el_path.end_with?('.rb')

                if cr_el_path.start_with?(el_path) && el_path.size < cr_el_path.size
                  status = true
                  break
                end
              end
              status
            end
          end

        end

      end
    end
  end
end
