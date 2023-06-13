# The Helper class provides utility methods for various tasks.
class Helper
    # Finds lproj localization files in the specified path.
    #
    # @param path [String] The path to search for localization files.
    # @return [Array<String>] An array of language codes found in the path.
    def self.find_lproj(path)
      lproj_files = Dir.glob("#{path}/*.lproj").select { |f| File.directory? f }
      return lproj_files.map { |f| File.basename(f, ".lproj") }
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
                if string_base.value == string_target.value
                keys[key_base] = key_target
                end
            end
        end
        return keys
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
        strings_a.each do |key, string_a|
            if !strings_b.has_key?(key)
                lost_keys << key
            end
        end
        return lost_keys
    end
end
  