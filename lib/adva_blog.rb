# require "adva_blog/version"
require "rails"

module AdvaBlog
  class Engine < Rails::Engine
    config.to_prepare do
      Section.register_type "Blog"
    end
  end
end
