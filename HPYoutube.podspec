Pod::Spec.new do |s|
  s.name     = 'HPYoutube'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'Youtube API search'
  s.author   = { 'Herve Peroteau' => 'herve.peroteau@gmail.com' }
  s.description = 'API Youtube search'
  s.platform = :ios
  s.ios.deployment_target = "7.0"
  s.source = { :git => "https://github.com/herveperoteau/HPYoutube.git"}
  s.source_files = 'HPYoutube'
  s.requires_arc = true
  s.dependency 'AFNetworking'
end

