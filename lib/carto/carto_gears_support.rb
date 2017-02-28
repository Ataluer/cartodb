# Support to dynamic CartoGears loading
# Inspired by BootInquirer at https://github.com/taskrabbit/rails_engines_example/blob/17b5ee5286c2186951312cbe440b8d21738596eb/lib/boot_inquirer.rb
module Carto
  class CartoGearsSupport
    # Returns gears found at:
    # - `gears` Rails root dir.
    # - `CARTO_GEARS_LOCAL` environment variable. Those are assumed to be at the same level than Rails root.
    def gears
      (gears_dir_gears + local_gears)
    end

    private

    def gears_dir_gears
      Dir['gears' + '/*/*.gemspec'].map do |gemspec_file|
        Carto::Gear.new(File.basename(gemspec_file, File.extname(gemspec_file)), File.dirname(gemspec_file))
      end
    end

    def local_gears
      (ENV['CARTO_GEARS_LOCAL'] || '').split.map do |gear_name|
        Carto::Gear.new(gear_name, "../#{gear_name.strip}")
      end
    end
  end

  class Gear
    def initialize(gem_name, path)
      @gem_name = gem_name
      @path = path
    end

    attr_reader :path

    def engine
      module_name = @gem_name.classify
      module_name << 's' if @gem_name[-1] == 's'
      # module_name.constantize.const_get(:Engine)
      "#{module_name}::Engine".constantize
    end
  end
end
