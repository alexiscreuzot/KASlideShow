Pod::Spec.new do |s|
  s.name     = 'KASlideShow'
  s.version  = '2.4'
  s.platform = :ios
  s.license  = {:type =>'MIT', :file =>'LICENSE'}
  s.summary  = 'Slideshow with fade and slide transitions.'
  s.homepage = 'https://github.com/kirualex/KASlideShow'
  s.author   = { 'Alexis Creuzot' => 'alexis.creuzot@gmail.com' }
  s.source   = { :git => 'https://github.com/kirualex/KASlideShow.git',
                  :tag => '2.4'}

  s.description = 'Slideshow for iOS. Easy to use. Support manual or automatic slideshow, with fade and slide transitions.'

  s.source_files = 'KASlideShow/*.{h,m}'
  s.requires_arc =  true
  s.framework = 'Foundation'
end