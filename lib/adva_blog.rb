# require "adva_blog/version"
require "rails"

# FIXME there's gotta be a better way!
spec = Gem::Specification.find_by_name("adva")
require "#{spec.gem_dir}/app/models/section"

module AdvaBlog
  class Engine < Rails::Engine
    initializer "adva_blog.init" do
      ::Section.register_type 'Blog'
    end
  end
end
