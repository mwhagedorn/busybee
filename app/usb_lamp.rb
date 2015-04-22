
DC_VENDOR = 0x1D34
DC_PRODUCT= 0x0004

USB_TYPE_CLASS      = 0x20
USB_RECIP_INTERFACE = 0x01

class UsbLamp
  attr_accessor :device,:color

  def initialize
    matchingDict = IOServiceMatching(KIOUSBDeviceClassName);
    unless matchingDict
      NSLog("couldnt create USB matching dictionary")
    end

    masterPort = mach_port_t.new
    CFDictionarySetValue(matchingDict,KUSBVendorID,DC_VENDOR)
    CFDictionarySetValue(matchingDict, KUSBProductName, DC_PRODUCT)



  end

  def green

  end

  def red

  end


end
