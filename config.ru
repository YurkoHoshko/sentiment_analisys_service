require File.expand_path('../config/environment', __FILE__)

run Rack::URLMap.new({
  "/sessions"       => Controllers::Sessions,
  "/registrations"  => Controllers::Registrations,
  "/reports"        => Controllers::Reports,
  "/"               => Controllers::Base
})