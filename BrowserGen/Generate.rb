#!/usr/bin/env ruby
#encoding: UTF-8

#  Generate.sh
#  BrowserGen
#
#  Created by Ian Gregory on 16-08-2018.
#  Copyright © 2018 ThatsJustCheesy. All rights reserved.

require 'fileutils'
require 'tmpdir'

$app_template_dir = File.join(__dir__, 'Generated Browser.app')
$site_name = gets.chomp
$homepage = gets.chomp
$initial_text_size = gets.chomp
$app_icon_path = gets.chomp

def continue_with_tmpdir(tmpdir)
  template_dir = File.join(tmpdir, $site_name + '.app')
  FileUtils.copy_entry($app_template_dir, template_dir)
  contents_dir = File.join(template_dir, 'Contents')
  resources_dir = File.join(contents_dir, 'Resources')
  
  if $app_icon_path != "[none]"
    `osascript - <<APPLESCRIPT
      use framework "Cocoa"
      prop NSImage : ref current application's class "NSImage"
      prop NSWorkspace : ref current application's class "NSWorkspace"
      set image to NSImage's alloc()'s initWithContentsOfFile:("#{$app_icon_path}")
      tell NSWorkspace's sharedWorkspace() to setIcon:image forFile:("#{template_dir}") options:0
    APPLESCRIPT`
#    FileUtils.copy($app_icon_path, resources_dir) # Doesn't work; must make icns, or use the above approach
  end

  info_plist_loc = File.join(contents_dir, 'Info.plist')
  $bundle_id = "com.justcheesy.GeneratedBrowser#{`uuidgen | tr -d '\n'`}"
  `defaults write '#{info_plist_loc}' CFBundleIdentifier '"#{$bundle_id}"'`
  `defaults write '#{info_plist_loc}' CFBundleName '"#{$site_name}"'`
#  `defaults write '#{info_plist_loc}' CFBundleIconFile '"#{File.basename($app_icon_path, File.extname($app_icon_path))}"'`

  def defaults_write_str(key, string_value)
    `defaults write "#{$bundle_id}" "#{key}" '"#{string_value}"'`
  end
  defaults_write_str 'siteName', $site_name
  defaults_write_str 'homepage', $homepage
  defaults_write_str 'initialTextSize', $initial_text_size
  
  lproj_dir = File.join(resources_dir, 'en.lproj') # Only en for now
  mainmenu_strings_loc = File.join(lproj_dir, 'MainMenu.strings')
  File.open(mainmenu_strings_loc, 'r+:UTF-8') do |file|
    modified_contents = file.read.gsub(/\bBrowserGen\b/, $site_name)
    file.seek(0)
    file.write(modified_contents)
  end

  if $app_icon_path == "[none]" # Resign bundle
    `codesign -s '-' -f --entitlements '#{File.join(resources_dir, 'Generated Browser.entitlements')}' '#{template_dir}'`
  else # codesign won't let us sign with the custom file icon, and I really
       # can't be bothered to generate a proper icns every time; just delete
       # any signature that exists (this is already hella insecure)
    puts 'Custom icon set for generated browser; deleting its code signature'
    FileUtils.rm_r File.join(contents_dir, '_CodeSignature')
  end

  install_dir = '/Applications'
  dest_name = File.basename(template_dir, File.extname(template_dir))
  dest_ext = File.extname(template_dir)
  dest_filename = dest_name + dest_ext
  dest_suffix = ''
  while File.exist?(File.join(install_dir, dest_filename))
    dest_suffix = (dest_suffix.to_i + 1).to_s
    dest_filename = dest_name + dest_suffix + dest_ext
  end
  `ditto '#{template_dir}' '#{File.join(install_dir, dest_filename)}'`
end

Dir.mktmpdir 'BGen' do |tmpdir|
  continue_with_tmpdir(tmpdir)
end

while gets
  puts $_
end
