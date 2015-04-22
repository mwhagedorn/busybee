# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'


begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Busy Bee'
  app.pods do
    pod 'ASDBeanProxy', :git => "https://github.com/mwhagedorn/ASDBeanProxy.git", :tag => '0.0.5'
    pod 'LTIOUSB', :git => "https://github.com/mwhagedorn/LTIOUSB.git", :tag => '0.0.2'
  end
  app.frameworks_dependencies << 'IOKit'
  app.bridgesupport_files << '/System/Library/Frameworks/IOKit.framework/Resources/BridgeSupport/IOKit.bridgesupport'
end

MotionBundler.setup
