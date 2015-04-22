class DreamCheekyUSBDevice < LTIOUSBDevice
  def deviceConnected
    if createPluginInterface
        NSLog("createPluginInterface")
    end
    if createDeviceInterface
        NSLog("createDeviceInterface:")
    end
  end


end
