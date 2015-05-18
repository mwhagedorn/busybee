class BeanDevicesManager
  #attr_accessor :devices
  attr_accessor :beans
  #attr_accessor :bean

  def initialize
   bean_mgr.delegate = self
   bean_mgr.startScanningForBeans
   @beans = []
  end


  def didUpdateDiscoveredBeans(discoveredBeans, withBean: newBean)
    NSLog("didUpdateDiscoveredBeans")
    #add_to_collection(newBean)
  end

  def didConnectToBean(bean)
    NSLog("didConnectToBean")
    #bean.setArduinoPowerState(ArduinoPowerState_Off)
    add_to_collection(bean)
  end


  def add_to_collection(bean)
    NSLog("addBeanToCollection")
    count = beans.count
    if !beans.any?{|bean| bean.isEqualToBean(bean)}
      beans.addObject(bean)
      send_beans_notification
    end
  end

  def remove_from_collection(bean)
    beans.removeObject(bean)
    send_beans_notification
  end

  def didDisconnectFromBean(bean)
    NSLog("didDisconnectFromBean")
    remove_from_collection(bean)
  end

  def applicationWillTerminate(notification)
    bean_mgr.stopScanningForBeans
  end

  def bean_green(bean)
    bean.setLedColor(NSColor.greenColor) if bean
  end

  def bean_red(bean)
    bean.setLedColor(NSColor.redColor) if bean
  end

  def bean_clear(bean)
    setLedColor = NSColor.colorWithDeviceRed(0.0, green:0.0,blue:0.0,alpha:1.0)
    bean.setLedColor(setLedColor) if bean
  end


  def send_beans_notification
    NSLog("BeansChanged Notification")
    NSNotificationCenter.defaultCenter.postNotification(NSNotification.notificationWithName("ASDBeansChanged",object:nil))
  end

  private
  def bean_mgr
    ASDBeanProxy.sharedASDBeanProxy
  end
end
