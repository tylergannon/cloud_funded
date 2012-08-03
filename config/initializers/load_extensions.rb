String.send :include, ::Extensions::StringExtensions
CloudFunded::Application.config.action_view.default_form_builder = MoneyFormBuilder
