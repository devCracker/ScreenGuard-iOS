Pod::Spec.new do |s|
  s.name          = "ScreenGuard"
  s.version       = "0.0.1"
  s.summary       = "Simple lib to protect the app from screen capture and record"
  s.description   = <<-DESC
simple lib to solve most iOS developers pain to protect the screenshot.
                        DESC
  s.homepage      = "https://github.com/devcracker/"
  s.license       = "MIT"
  s.author        = "devCracker"
  s.platform      = :ios, "11.0"
  s.source        = {
    :git => "https://github.com/devcracker/ScreenGuard-iOS.git",
    :tag => "#{s.version}"
  }
  s.source_files = 'ScreenGuard/**/*.{swift,m,h}'
end
