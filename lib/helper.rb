# frozen_string_literal: true

require "./lib/logger"

# The Helper class provides utility methods for various tasks.
class Helper
  # Finds lproj localization files in the specified path.
  #
  # @param path [String] The path to search for localization files.
  # @return [Array<String>] An array of language codes found in the path.
  def self.find_lproj(path)
    lproj_files = Dir.glob("#{path}/*.lproj").select { |f| File.directory? f }
    lproj_files.map { |f| File.basename(f, ".lproj") }
  end

  # Creates a dictionary mapping keys between two localization files.
  #
  # @param base_file [String] The base localization file path.
  # @param target_file [String] The target localization file path.
  # @return [Hash<String, String>] A hash containing key mappings.
  def self.make_keys_dict(base_file, target_file)
    strings_base = LocoStrings.load(base_file).read
    strings_target = LocoStrings.load(target_file).read
    keys = {}
    strings_base.each do |key_base, string_base|
      strings_target.each do |key_target, string_target|
        keys[key_base] = key_target if string_base.value == string_target.value
      end
    end
    keys
  end

  # Finds missing keys in the target localization file compared to the base file.
  #
  # @param file_a [String] The base localization file path.
  # @param file_b [String] The target localization file path.
  # @return [Array<String>] An array of missing keys in the target file.
  def self.find_missing(file_a, file_b)
    strings_a = LocoStrings.load(file_a).read
    strings_b = LocoStrings.load(file_b).read

    lost_keys = []
    strings_a.each do |key, _string_a|
      lost_keys << key unless strings_b.key?(key)
    end
    lost_keys
  end

  # Merges the source strings into the target strings
  #
  # @param source [Hash] The source strings hash
  # @param _target [Hash] The target strings hash (not used in this method)
  # @param keys [Hash] A dictionary mapping source keys to target keys
  # @param lost_keys [Array] An array of lost keys to be updated
  #
  # @return [void]
  def self.merge(source, _target, keys, lost_keys)
    source.each do |key, source_string|
      target_key = keys[key]
      next unless target_key
      next unless lost_keys.include?(target_key)

      strings_b_file.update(target_key, source_string.value)
      lost_keys.delete(target_key)
      Logger.string_value(target_key, source_string.value)
    end
  end
end
