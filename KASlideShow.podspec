Pod::Spec.new do |s|
  s.name     = 'KASlideShow'
  s.version  = '0.1'
  s.platform = :ios
  s.license  = 'MIT'
  s.summary  = 'Basic iOS slideshow.'
  s.homepage = 'https://github.com/kirualex/KASlideShow'
  s.author   = { 'Alexis Creuzot' => 'alexis.creuzot@gmail.com' }
  s.source   = { :git => 'https://github.com/kirualex/KASlideShow'}

  s.description = 'KASlideShow by kirualex.'

  s.source_files = 'KASlideShow/*.{h,m}'
  s.requires_arc =  true
  s.framework = 'Foundation'
end