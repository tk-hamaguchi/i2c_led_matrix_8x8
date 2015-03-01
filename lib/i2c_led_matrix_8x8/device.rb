module I2cLedMatrix8x8
  class Device
    def initialize(address, path='/dev/i2c-1')
      @address = address
      @device = I2C.create(path)

      @device.write(@address, 0x21)
      @device.write(@address, 0x80)
      (0x00..0x0e).step(2) do |register|
        @device.write(@address, register, 0x00)
      end
    end

    def write(table)
      ta = table.map do |array|
        a = array.dup
        Integer('0b' + ([a.shift] + a.reverse).map(&:to_i).join())
      end

      i = 0
      (0x00..0x0e).step(2) do |register|
        @device.write(@address, register, ta[i])
        i = i + 1
      end

      @device.write(@address, 0x81)
    end

    def brightness(level)
      @device.write(@address, 0xe0 + level)
    end
  end
end
