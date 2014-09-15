
Pod::Spec.new do |s|

  s.name         = "KNMSegueRouting"
  s.version      = "0.2.0"
  s.homepage     = "https://github.com/konoma/ios-segue-routing"
  s.summary      = "Allow preparing for UIStoryboardSegue using explicit methods and configuration blocks"
  s.description  = """
  This category analyzes calls to -prepareForSegue:sender:
  and routes them based on the segue identifier. So for a 'Show Settings'
  segue, -prepareForShowSettingsSegue:sender: is called.

  Additionally you can prepare for segues which are explicitly performed using
  a configuration block.
  """

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Markus Gasser" => "markus.gasser@konoma.ch" }

  s.source       = { :git => "git@github.com:konoma/ios-segue-routing.git", :tag => '0.2.0' }

  s.platform = :ios, '7.0'
  
  s.source_files        = 'Sources/*.{h,m}'
  s.public_header_files = 'Sources/*.h'
  s.requires_arc        = true
  s.frameworks          = 'Foundation', 'UIKit'
  
end
