Pod::Spec.new do |s|
  s.name             = "SSCalendarPicker"
  s.version          = "1.0.0"
  s.summary          = "Colourful calendar component for iOS written in Swift"
  s.description      = <<-DESC
Features
1. Single selection and multiselection option
2. Customization on changing the colors of the dates
3. Delegates to capture teh selected dates
4. Option to define the calendar start and ending year
DESC

  s.homepage         = "https://bitbucket.org/saravudh/sscalendarpicker"
  s.license          = 'MIT'
  s.author           = { "Saravudh Sinsomros" => "saravudh@shorsher.com" }
  s.source           = { :git => "https://saravudh@bitbucket.org/saravudh/sscalendarpicker.git", :tag => '1.0.10' }
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = 'EPCalendar/EPCalendarPicker'
  s.frameworks = 'UIKit'
  s.resources        = ["EPCalendar/EPCalendarPicker/EPCalendarCell1.xib", "EPCalendar/EPCalendarPicker/EPCalendarHeaderView.xib", "EPCalendar/EPCalendarPicker/SSCalendarPicker.storyboard", "EPCalendar/EPCalendarPicker/icon.xcassets"]
end
