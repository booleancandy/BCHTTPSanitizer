version = '0.1.0'

Pod::Spec.new do |s|
  s.name         = 'BCHTTPSanitizer'
  s.version      = version
  s.summary      = 'Library for cleaning sensitive data from HTTP requests and responses.'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author = {
    'Tim Potter' => 'tpot@booleancandy.com.au'
  }
  s.homepage = 'https://github.com/booleancandy/BCHTTPSanitizer'
  s.social_media_url = 'https://twitter.com/BooleanCandy'
  s.source = {
    :git => 'https://github.com/booleancandy/BCHTTPSanitizer.git',
    :tag => 'v#{version}'
  }
  s.source_files = 'BCHTTPSanitizer/*.[hm]'
  s.requires_arc = true
end
