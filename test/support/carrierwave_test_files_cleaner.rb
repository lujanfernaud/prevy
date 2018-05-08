require "fileutils"

class CarrierWaveTestFilesCleaner

  def self.run
    puts "\nCleaning CarrierWave test uploads:"

    Dir.glob(CARRIERWAVE_TEST_ROOT.join("*")).each do |dir|
      puts "- #{dir}"

      FileUtils.remove_entry(dir)
    end

    puts "\n"
  end

end
