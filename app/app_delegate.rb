class AppDelegate

  attr_accessor :beans

  def applicationDidFinishLaunching(notification)
    @beans = []
    @beanm = BeanDevicesManager.new

    buildMenu
    buildWindow
    buildTableView



    NSNotificationCenter.defaultCenter.addObserver self,
      selector:"didFindUSBDevice:",
      name:LTIOUSBDeviceConnectedNotification,
      object:nil

    NSNotificationCenter.defaultCenter.addObserver self,
      selector:"didLoseUSBDevice:",
      name:LTIOUSBDeviceDisconnectedNotification,
      object:nil

    NSNotificationCenter.defaultCenter.addObserver self,
                                                   selector: "didChangeDiscoveredBeans:",
                                                   name: "ASDBeansChanged",
                                                   object:   nil


  end


 #TODO ASDBeanProxy has delegate methods... implement them

  def applicationWillTerminate(notification)
    ASDBeanProxy.sharedASDBeanProxy.stopScanningForBeans
  end


  def didChangeDiscoveredBeans(notification)
    self.beans = @beanm.beans
    NSLog("AppDelegate::beans changed")
    @table.reloadData
  end

  def led_red(sender)
    @beanm.bean_red
  end

  def led_clear(sender)
    @beanm.bean_clear
  end

  def led_green(sender)
    @beanm.bean_green
  end



  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @telecomController = TelecomController.new @mainWindow
    @mainWindow.orderFrontRegardless
  end

  def buildTableView
    scrollView                  = NSScrollView.alloc.initWithFrame(@mainWindow.contentView.bounds)
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable
    scrollView.hasVerticalScroller = true

    @table          = NSTableView.alloc.initWithFrame(scrollView.bounds)
    @table.delegate = self
    @table.dataSource = self

    column1          = NSTableColumn.alloc.initWithIdentifier('status')
    column1.editable = false
    column1.headerCell.title = 'Status'
    column1.width    = 40
    @table.addTableColumn(column1)

    column2          = NSTableColumn.alloc.initWithIdentifier('name')
    column2.editable = false
    column2.headerCell.title = 'Name'
    column2.width    = 80
    @table.addTableColumn(column2)

    column3          = NSTableColumn.alloc.initWithIdentifier('identifier')
    column3.editable = false
    column3.headerCell.title = 'Identifier'
    column3.width    = 280
    @table.addTableColumn(column3)

    scrollView.documentView = @table
    @mainWindow.contentView.addSubview(scrollView)

  end


  #tableView delegate methods
  def tableView(aTableView, objectValueForTableColumn:aTableColumn, row:rowIndex)
    case aTableColumn.identifier
      when "status"
        case self.beans.objectAtIndex(rowIndex).state
          when BeanState_Discovered
            return "Discovered"
          when BeanState_ConnectedAndValidated
            return "Validated"
          else
            return "Unknown"
        end
      when "name"
        return self.beans.objectAtIndex(rowIndex).name
      when "identifier"
        return self.beans.objectAtIndex(rowIndex).identifier.UUIDString
      else
        return "Unknown"
    end
    #return self.beans.objectAtIndex(rowIndex).name
  end

  def numberOfRowsInTableView(tableView)
    self.beans.count
  end


  #def toggle_led(sender)
  #  if @LEDstate
  #    @LEDstate = false
  #    if bean.state == BeanState_ConnectedAndValidated
  #      bean.setLedColor = nil
  #    end
  #  else
  #    self.change_led_color(self)
  #  end
  #end
  #
  #def change_led_color(sender)
  #  if bean.state == BeanState_ConnectedAndValidated
  #    bean.setLedColor(LEDColorWell.color)
  #  end
  #  @LEDstate = true
  #end

 def validateUserInterfaceItem(anItem)
  NSLog("validateUserInterfaceItem")
  theAction = anItem.action

  if theAction == "led_red:" || theAction == "led_green:" ||theAction == "led_clear:"
    if @beanm.bean
      return true
    else
      return false
    end
  end
  return true
 end









end
