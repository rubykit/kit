module Kit::Geolocation::Admin::Tables
  class BaseTable < Kit::ActiveAdmin::Table
    include Kit::Geolocation::Routes

    def attr_type_flag(type, name, functor)
      send(type, name) do |el|
        if (val = functor.call(el).try :iso3166_alpha2)
          ctx.i :'class' => "famfamfam-flag-#{val.downcase}"
        else
          nil
        end
      end
    end

    def attr_type_country(type, name, functor)
      send(type, name) do |el|
        if (country = functor.call(el))
          ctx.a(href: Kit::Geolocation::Routes.admin_country_path(country)) do
            [ctx.i(:'class' => "famfamfam-flag-#{country.iso3166_alpha2.downcase}"), ctx.code(country.name)]
          end
        else
          nil
        end
      end
    end

  end
end