Pod::Spec.new do |s|
  s.name             = "BBUpdate"
  s.version          = "1.0"
  s.summary          = "一行代码实现程序更新提醒"
  s.description      = <<-DESC
                       一行代码实现程序更新提醒，还可以设置确定取消等提示内容
                       DESC
  s.homepage         = "https://github.com/zyvv/BBUpdate"
  s.license          = 'MIT'
  s.author           = { "zyvv" => "zhangyangv@foxmail.com" }
  s.source           = { :git => "https://github.com/zyvv/BBUpdate.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'BBUpdate/*.{h,m}'
end