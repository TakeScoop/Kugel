Pod::Spec.new do |s|

  s.name         = "Kugel"
  s.version      = "0.0.1"
  s.summary      = "A glorious Swift wrapper around NSNotificationCenter"

  s.description  = <<-DESC
                   Easily publish/subscribe/unsubscribe to/from notifications with
	           a convenient Swift syntax for NSNotificationCenter.
                   DESC

  s.homepage     = "https://github.com/TakeScoop/Kugel"
  s.license      = "MIT"
  s.author       = { "Loïs Di Qual" => "lois@takescoop.com" }

  s.source       = { :git => "git@github.com:TakeScoop/Kugel.git" }
  s.source_files = "Kugel/Kugel.swift"

  s.requires_arc = true
  s.osx.deployment_target = "10.9"
  s.ios.deployment_target = "8.0"

end
