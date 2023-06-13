# frozen_string_literal: true

require "thor"
require "loco_strings"
require "./lib/logger"
require "./lib/helper"

# The Locotool class represents a CLI tool for localization tasks.
#
# Usage: locotool [command] [options]
class Locotool < Thor
  desc "dublicates FILE_A FILE_B", "Find duplicate keys in localization files"
  def dublicates(file_a, file_b)
    strings_a = LocoStrings.load(file_a).read
    strings_b = LocoStrings.load(file_b).read

    strings_a.each do |key, string_a|
      next unless strings_b.key?(key)

      if string_a.value == strings_b[key].value
        Logger.string(string_a)
      else
        Logger.duplicate(string_a, strings_b[key])
      end
    end
  end

  desc "sync_ios_auto PATH_A PATH_B BASE_LANG", "Find and sync iOS localization files"
  def sync_ios_auto(path_a, path_b, base_lang)
    target_langs = Helper.find_lproj(path_a)
    target_langs.each do |target_lang|
      next if target_lang == base_lang

      Logger.header("Language #{Paint[target_lang.to_s, :green]}")
      sync_ios(path_a, path_b, base_lang, target_lang)
    end
  end

  desc "sync PATH_A PATH_B BASE_LANG TARGET_LANG", "Sync iOS localization files"
  def sync_ios(path_a, path_b, base_lang, target_lang)
    file_a_base = "#{path_a}/#{base_lang}.lproj/Localizable.strings"
    file_a_target = "#{path_a}/#{target_lang}.lproj/Localizable.strings"
    file_b_base = "#{path_b}/#{base_lang}.lproj/Localizable.strings"
    file_b_target = "#{path_b}/#{target_lang}.lproj/Localizable.strings"
    unless File.exist?(file_b_target)
      Logger.file_not_found(file_b_target)
      return
    end
    sync(file_a_base, file_a_target, file_b_base, file_b_target)
  end

  desc "sync FILE_A_BASE FILE_A_TARGET FILE_B_BASE FILE_B_TARGET", "Sync localization files"
  def sync(file_a_base, file_a_target, file_b_base, file_b_target)
    strings_a_file = LocoStrings.load(file_a_target)
    strings_a_target = strings_a_file.read
    strings_b_file = LocoStrings.load(file_b_target)
    strings_b_file.read

    lost_keys = Helper.find_missing(file_b_base, file_b_target)
    keys_b_to_a = Helper.make_keys_dict(file_a_base, file_b_base)
    Helper.merge(strings_a_target, strings_b_file, keys_b_to_a, lost_keys)

    Logger.lost_keys(lost_keys)
    strings_b_file.write
  end
end

Locotool.start(ARGV)
