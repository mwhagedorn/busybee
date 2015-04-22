class BeanDevicesManager
  attr_accessor :devices
  attr_accessor :beans
  attr_accessor :bean

  def initialize
   bean_mgr.delegate = self
   bean_mgr.startScanningForBeans
   @beans = NSMutableArray.new
  end


  def didUpdateDiscoveredBeans(discoveredBeans, withBean: newBean)
    self.beans= discoveredBeans
    NSLog("didUpdateDiscoveredBeans")
    add_to_collection(newBean)
  end

  def didConnectToBean(bean)
    NSLog("didConnectToBean")
    bean.setArduinoPowerState(ArduinoPowerState_Off)
    add_to_collection(bean)
  end

  def add_to_collection(bean)
    unless self.beans.detect{|b| b.isEqualTo(bean)}
      NSLog("added")
      self.beans << bean
      send_beans_notification
    else

      NSLog("condition:"+(self.beans.detect { |b| b.isEqualTo(bean) } ? "true" : "false"))
    end
  end

  def remove_from_collection(bean)
    if self.beans.reject!{|b| b.isEqualTo(bean)}
      NSLog("deleted")
      send_beans_notification
    end
  end

  def didDisconnectFromBean(bean)
    NSLog("didDisconnectFromBean")
    remove_from_collection(bean)
  end

  def applicationWillTerminate(notification)
    bean_mgr.stopScanningForBeans
  end

  def bean_green
    set_bean_color(NSColor.greenColor)
  end

  def bean_red
     set_bean_color(NSColor.redColor)
  end

  def bean_clear
    set_bean_color(NSColor.colorWithDeviceRed(0.0, green:0.0,blue:0.0,alpha:1.0))
  end

  def set_bean_color(color)
    #NSColor
    @bean.setLedColor(color)
  end

  def send_beans_notification
    NSNotificationCenter.defaultCenter.postNotification(NSNotification.notificationWithName("ASDBeansChanged",object:nil))
  end

  private
  def bean_mgr
    ASDBeanProxy.sharedASDBeanProxy
  end
end
