spec = Gem::Specification.new do |s|
  s.name              = "absolutize"
  s.version           = "0.0.9"
  s.author            = "Stewart McKee"
  s.email             = "stewart.mckee@vamosa.com"
  s.homepage          = "http://github.com/vamosa/absolutize"
  s.platform          = Gem::Platform::RUBY
  s.summary           = "URI Absolitizing parser"
  s.files             = Dir["{spec,lib}/**/*"].delete_if { |f| f =~ /(rdoc)$/i }
  s.require_path      = "lib"
  s.has_rdoc          = false
  s.extra_rdoc_files  = ["README.textile"]
end
