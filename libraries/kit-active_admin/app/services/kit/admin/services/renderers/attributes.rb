module Kit::Admin::Services::Renderers::Attributes

  def self.types
    ns = Kit::Admin::Services::Renderers::Attributes

    @attrs ||= {
      amount:              ns::Amount,
      amount_tag:          ns::Amount,
      auto_link:           ns::AutoLink,
      bool:                ns::Boolean,
      boolean:             ns::Boolean,
      code:                ns::Code,
      code_link_to:        ns::CodeLinkTo,
      code_with_color:     ns::CodeWithColor,
      color:               ns::Color,
      color_tag:           ns::Color,
      color_tag_with_code: ns::CodeWithColor,
      date:                ns::Date,
      date_tag:            ns::Date,
      img:                 ns::Img,
      img_link_to:         ns::ImgLinkTo,
      json_readonly:       ns::JsonReadonly,
      model:               ns::Model,
      model_color:         ns::ModelColor,
      model_id:            ns::ModelId,
      model_verbose:       ns::ModelVerbose,
      percentage_bar:      ns::PercentageBar,
      pre:                 ns::Pre,
      pre_yaml:            ns::PreYaml,
      status:              ns::Status,
      status_tag:          ns::Status,
    }
  end

end
