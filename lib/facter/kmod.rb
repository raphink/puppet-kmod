Facter.add(:kmods) do
  confine :kernel => :linux
  confine File.exists?('/sys/module')

  kmod = {}

  setcode do
    Dir.foreach('/sys/module') do |directory|
      next if directory == '.' or directory == '..'

      kmod[directory] = {
        :parameters => {},
        :used_by => [],
      }

      Dir.glob("/sys/module/#{directory}/parameters/*") do |param|
        kmod[directory][:parameters][param] = File.read("/sys/module/#{directory}/parameters/#{param}", 'r')
      end

      Dir.glob("/sys/module/#{directory}/holders/*") do |used|
        kmod[directory][:used_by] << used
      end

    end

    kmod
  end
end
