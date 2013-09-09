Pod::Spec.new do |s|
  s.name     = 'RASwipeTableViewCell'
  s.version  = '1.0.0'
  s.author   = { 'Oscar Lakra' => 'developer@oscarlakra.com' }
  s.homepage = 'https://github.com/olakra/RASwipeTableViewCell'
  s.summary  = 'Inspired by the "Twitter.app" the aim is to create an extended UITableViewCell that would allow for two content views on the same table cell.'
  s.license  = 'MIT'
  s.source   = { :git => 'https://github.com/olakra/RASwipeTableViewCell.git', :tag => '1.0.0' }
  s.source_files = 'RASwipeTableViewCell'
  s.platform = :ios
  s.ios.deployment_target = '6.0'
  s.requires_arc = true
end
