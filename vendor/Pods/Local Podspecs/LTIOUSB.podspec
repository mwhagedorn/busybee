Pod::Spec.new do |s|

    s.name              = 'LTIOUSB'
    s.version           = '0.0.1'
    s.summary           = 'Description of your project'
    s.homepage          = 'https://github.com/mwhagedorn/LTIOUSB'
    s.license           = {
        :type => 'MIT',
        :file => 'LICENSE.txt'
    }
    s.author            = {
        'Mike Hagedorn' => 'mike@silverchairsolutions.com'
    }
    s.source            = {
        :git => 'https://github.com/mwhagedorn/LTIOUSB.git',
        :tag => s.version.to_s
    }
    s.platform = :osx, "10.8"
    s.source_files      = 'Library/*.{m,h}'
    s.requires_arc      = true

end
