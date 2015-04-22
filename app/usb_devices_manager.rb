class USBDevicesManager
  attr_accessor :devmgr, :device


  DC_VENDOR = 0x1D34
  DC_PRODUCT= 0x0004

  def initialize
    @devmgr = LTIOUSBManager.sharedInstance

    @devmgr.startWithMatchingDictionary(LTIOUSBManager.matchingDictionaryForProductID(DC_PRODUCT, vendorID:DC_VENDOR, objectBaseClass:DreamCheekyUSBDevice))

    NSNotificationCenter.defaultCenter.addObserver self,
      selector:"didFindUSBDevice:",
      name:LTIOUSBDeviceConnectedNotification,
      object:nil

    NSNotificationCenter.defaultCenter.addObserver self,
      selector:"didLoseUSBDevice:",
      name:LTIOUSBDeviceDisconnectedNotification,
      object:nil



  end

  def didFindUSBDevice(notification)
    @device = notification.object.first
    NSLog("USBDevicesManager::found device")
    red
  end

  def didLoseUSBDevice(notification)
    @device = nil
    NSLog("USBDevicesManager::device disconnected")
  end

  def color(color_struct)
    @color = color_struct
    color_msg = [@color.red,@color.green,@color.blue, 0x00, 0x00, 0x00, 0x00, 0x05]
    send_msg(color_msg)
  end

  def red
    the_color = ColorStruct.new
    the_color.red = 0xFF
    color(the_color)
  end

  def green
    the_color = ColorStruct.new
    the_color.green = 0xFF
    color(the_color)
  end

  def blue
    the_color = ColorStruct.new
    the_color.blue = 0xFF
    color(the_color)
  end

  def white
    the_color = ColorStruct.new
    color(the_color)
  end


  private
    def send_msg(message)

      return unless @device
      #setup data
      data1 = [0x1f, 0x02, 0x00, 0x2e, 0x00, 0x00, 0x2b, 0x03]
      data2 = [0x00, 0x02, 0x00, 0x2e, 0x00, 0x00, 0x2b, 0x04]
      data3 = [0x1f, 0x02, 0x00, 0x2e, 0x00, 0x00, 0x2b, 0x03]

      #   typedef struct {
      #     UInt8       bmRequestType;
      #     UInt8       bRequest;
      #     UInt16      wValue;
      #     UInt16      wIndex;
      #     UInt16      wLength;
      #     void *      pData;
      #     UInt32      wLenDone;
      #     UInt32      noDataTimeout;
      #     UInt32      completionTimeout;
      # } IOUSBDevRequestTO;
      request = IOUSBDevRequestTO.new
      request.bmRequestType =  USBmakebmRequestType(KUSBOut, KUSBClass, KUSBInterface);
      request.bRequest = 0x09
      request.wValue = 0x200
      request.wIndex = 0x00

      unless @device.openDevice
        NSLog("Couldnt open device")
        return
      end

      unless @device.findFirstInterfaceInterface
        NSLog("couldnt find first interface")
        return
      else
        NSLog("located first interface")
      end


      unless @device.openInterface
        NSLog("couldnt open interface")
        return
      else
        NSLog("opened interface")
      end

      [data1,data2,data3,message].each do |msg|
        NSLog("send message")
        request.wLength = 64
        #pdata probably needs to be a Pointer.new...
        data = Pointer.new(:char)
        data = msg.pack("c*")
        request.pData = data
        if @device.sendControlRequestToPipe(0,request:request)
          NSLog("success")
        end
      end

      # @device.openInterface do |handle|
      #   [data1,data2,data3,message].each do |msg|
      #     handle.control_transfer(:bmRequestType => USB_TYPE_CLASS | USB_RECIP_INTERFACE,
      #                             :bRequest      => 0x09,
      #                             :wValue        => 0x200,
      #                             :wIndex        => 0x00,
      #                             :dataOut       => msg.pack("c*"))
      #   end
      end




end
