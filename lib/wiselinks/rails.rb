module Wiselinks
  module Rails
    class Engine < ::Rails::Engine
      initializer 'wiselinks.register_logger' do
        Wiselinks.options[:logger] = ::Rails.logger
      end

      initializer "wiselinks.register_extensions"  do
        ActionDispatch::Request.send :include, Request
        ActionController::Base.send :include, ControllerMethods
        ActionController::Base.send :include, Rendering
        ActionView::Base.send :include, Helpers
      end

      initializer "wiselinks.register_assets_digest"  do
        if ::Rails.application.config.assets.digest && Dir.glob('public/assets/manifest-*.json').any?
          Wiselinks.options[:assets_digest] ||= Digest::MD5.hexdigest(Sprockets::Manifest.new(::Rails.env, Dir.glob('public/assets/manifest-*.json').first).assets.values.join)
        end
      end
    end
  end
end
