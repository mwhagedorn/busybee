class TelecomController


  SKYPE_EVENT = "SKSkypeAPINotification"
  SKYPE_EVENT2 = "SKSkypeAttachResponse"
  SKYPE_RESPONSE = "SKYPE_API_NOTIFICATION_STRING"

  SKYPE_BUNDLE = "com.skype.skype"



  def initialize(window)
    @imPersonStatus = []
    @abPeople = []




		notifications = NSDistributedNotificationCenter.defaultCenter

		notifications.addObserver(self,selector:'recieved_skype_response:', name:SKYPE_EVENT, object:nil)
    NSNotificationCenter.defaultCenter.addObserver(self,selector:'recieved_lync_response:',name:'BBLyncStatusNotification', object:nil )
    NSNotificationCenter.defaultCenter.addObserver(self,selector:'recieved_skype_status:',name:'BBSkypeStatusNotification', object:nil )
    @log_watcher = LogWatcher.new
    @skype_parser = SkypeParser.new

    @fsm = StateMachine::Base.new start_state: :available, verbose: true


    @fsm.when :available do |state|
      state.on_entry { NSLog "I'm available, started and alive!" }
      state.transition_to(:busy, on: :unplaced, action: proc { NSLog("ANC");handle_on_the_phone })
      state.transition_to(:busy, on: :routing, action: proc { handle_on_the_phone })
      state.transition_to(:busy, on: :earlymedia, action: proc { handle_on_the_phone })
      state.transition_to(:busy, on: :ringing, action: proc { handle_on_the_phone })
      state.transition_to(:busy, on: :inprogress, action: proc { handle_on_the_phone })
      state.transition_to(:busy, on: :duration, action: proc { handle_on_the_phone })
     end

     @fsm.when :busy do |state|
       state.on_entry { NSLog "I'm busy, started and alive!" }
       state.transition_to(:available, on: :finished)
       state.transition_to(:available, on: :refused)
       state.transition_to(:available, on: :missed)
       state.transition_to(:available, on: :cancelled)
       state.on_exit do
         handle_not_on_the_phone
       end
     end

     @fsm.start!


  end

  def setupSkypeListeners

# 2014-08-12 17:33:21.466 busybee[11940:303] CALL 1283565 STATUS ROUTING
# 2014-08-12 17:33:21.469 busybee[11940:303] CALL 1283565 STATUS ROUTING
# 2014-08-12 17:33:21.595 busybee[11940:303] CALL 1283565 PARTNER_HANDLE jeffkramer
# 2014-08-12 17:33:24.098 busybee[11940:303] CALL 1283565 STATUS RINGING
# 2014-08-12 17:33:24.100 busybee[11940:303] CALL 1283565 STATUS RINGING
# 2014-08-12 17:33:40.719 busybee[11940:303] CALL 1283565 STATUS REFUSED
# 2014-08-12 17:33:40.937 busybee[11940:303] CALL 1283565 STATUS REFUSED
# 2014-08-12 17:33:41.034 busybee[11940:303] ERROR 24 Cannot hangup inactive call
# 2014-08-12 17:33:45.860 busybee[11940:303] CALL 1283693 STATUS RINGING
# 2014-08-12 17:33:45.863 busybee[11940:303] CALL 1283693 STATUS RINGING
# 2014-08-12 17:33:45.865 busybee[11940:303] CALL 1283693 STATUS RINGING
# 2014-08-12 17:33:45.868 busybee[11940:303] CALL 1283693 STATUS RINGING
# 2014-08-12 17:33:45.872 busybee[11940:303] CALL 1283693 CONF_ID 0
# 2014-08-12 17:33:45.990 busybee[11940:303] CALL 1283693 PARTNER_DISPNAME Jeff Kramer
# 2014-08-12 17:33:46.006 busybee[11940:303] CALL 1283693 CONF_ID 0
# 2014-08-12 17:33:50.622 busybee[11940:303] CALL 1283693 STATUS INPROGRESS
# 2014-08-12 17:33:50.628 busybee[11940:303] CALL 1283693 STATUS INPROGRESS
# 2014-08-12 17:33:50.678 busybee[11940:303] CALL 1283693 VIDEO_STATUS VIDEO_SEND_ENABLED
# 2014-08-12 17:33:50.684 busybee[11940:303] CALL 1283693 VIDEO_STATUS VIDEO_SEND_ENABLED
# 2014-08-12 17:33:51.131 busybee[11940:303] CALL 1283693 DURATION 1
# 2014-08-12 17:33:51.134 busybee[11940:303] CALL 1283693 DURATION 1
# 2014-08-12 17:33:52.105 busybee[11940:303] CALL 1283693 DURATION 2
# 2014-08-12 17:33:52.107 busybee[11940:303] CALL 1283693 DURATION 2
# 2014-08-12 17:33:53.111 busybee[11940:303] CALL 1283693 DURATION 3
# 2014-08-12 17:33:53.113 busybee[11940:303] CALL 1283693 DURATION 3
# 2014-08-12 17:33:53.474 busybee[11940:303] USER coderforrent NROF_AUTHED_BUDDIES 80
# 2014-08-12 17:33:53.477 busybee[11940:303] USER coderforrent NROF_AUTHED_BUDDIES 80
# 2014-08-12 17:33:54.104 busybee[11940:303] CALL 1283693 DURATION 4
# 2014-08-12 17:33:54.107 busybee[11940:303] CALL 1283693 DURATION 4
# 2014-08-12 17:33:55.122 busybee[11940:303] CALL 1283693 DURATION 5
# 2014-08-12 17:33:55.125 busybee[11940:303] CALL 1283693 DURATION 5
# 2014-08-12 17:33:56.209 busybee[11940:303] CALL 1283693 DURATION 6
# 2014-08-12 17:33:56.212 busybee[11940:303] CALL 1283693 DURATION 6
# 2014-08-12 17:33:57.145 busybee[11940:303] CALL 1283693 DURATION 7
# 2014-08-12 17:33:57.147 busybee[11940:303] CALL 1283693 DURATION 7
# 2014-08-12 17:33:58.124 busybee[11940:303] CALL 1283693 DURATION 8
# 2014-08-12 17:33:58.127 busybee[11940:303] CALL 1283693 DURATION 8
# 2014-08-12 17:33:59.111 busybee[11940:303] CALL 1283693 DURATION 9
# 2014-08-12 17:33:59.113 busybee[11940:303] CALL 1283693 DURATION 9
# 2014-08-12 17:34:00.101 busybee[11940:303] CALL 1283693 DURATION 10
# 2014-08-12 17:34:00.101 busybee[11940:303] CALL 1283693 DURATION 10
# 2014-08-12 17:34:01.117 busybee[11940:303] CALL 1283693 DURATION 11
# 2014-08-12 17:34:01.117 busybee[11940:303] CALL 1283693 DURATION 11
# 2014-08-12 17:34:02.108 busybee[11940:303] CALL 1283693 DURATION 12
# 2014-08-12 17:34:02.111 busybee[11940:303] CALL 1283693 DURATION 12
# 2014-08-12 17:34:03.112 busybee[11940:303] CALL 1283693 DURATION 13
# 2014-08-12 17:34:03.114 busybee[11940:303] CALL 1283693 DURATION 13
# 2014-08-12 17:34:04.134 busybee[11940:303] CALL 1283693 DURATION 14
# 2014-08-12 17:34:04.137 busybee[11940:303] CALL 1283693 DURATION 14
# 2014-08-12 17:34:04.403 busybee[11940:303] CALL 1283693 STATUS FINISHED
# 2014-08-12 17:34:04.407 busybee[11940:303] CALL 1283693 STATUS FINISHED


# system.log
# Aug 13 04:15:49 Faramir.local Microsoft Lync[5004]: Status changed to: eOnlineOnThePhone. Voicemail playing is allowed: NO
# Aug 13 04:16:01 Faramir.local Microsoft Lync[5004]: Render glitch happended - Timeline:13.500 sec, GlitchSamples:480, Duration:10.0 ms, BufferLength:20 ms
# Aug 13 04:16:01 Faramir.local Microsoft Lync[5004]: Allowing sleep for action 0
# Aug 13 04:16:01 Faramir.local Microsoft Lync[5004]: +++ Display sleep was successfully allowed
# Aug 13 04:16:01 Faramir.local Microsoft Lync[5004]: Phone Call is dropped. We can play VM
# Aug 13 04:16:03 Faramir.local Microsoft Lync[5004]: Status changed to: eOnlinePresent. Voicemail playing is allowed: YES


    # if(!@isConnected)
    #   NSDistributedNotificationCenter.defaultCenter.postNotificationName("SKSkypeAPIAvailabilityRequest" object:nil,userInfo:nil deliverImmediately:true)
    #   NSDistributedNotificationCenter.defaultCenter.postNotificationName("SKSkypeAPIAttachRequest" object:"skypeListener",userInfo:nil deliverImmediately:true)
    # end

  end


def recieved_skype_response(notification)
	userinfo = notification.userInfo
  responseMessage = userinfo.valueForKey(SKYPE_RESPONSE)
  @skype_parser.parse(responseMessage)

end

def recieved_skype_status(notification)
  userinfo = notification.userInfo
  responseMessage = userinfo.valueForKey("status")
  NSLog("Skype Status Message "+ responseMessage)
  @fsm.event(responseMessage.to_sym)
end

def recieved_lync_response(notification)
  userinfo = notification.userInfo
  responseMessage = userinfo.valueForKey("status")
  NSLog("Lync Message")
  NSLog(responseMessage)
  handle_lync_status(responseMessage)

end

def handle_lync_status(state)
  if state == "eOnlineOnThePhone"
    handle_on_the_phone
  end

  if state == "eOnlinePresent"
    handle_not_on_the_phone

  end

end

def handle_on_the_phone
  NSLog("On the Phone")
  notify_on
end

def handle_not_on_the_phone
 NSLog("Off the Phone")
 notify_off
end

def notify_on
  NSLog("***Send LED on***")
  NSNotificationCenter.defaultCenter.postNotificationName("ASDBeanLightRed", object:self)
end

def notify_off
  NSLog("***Send LED off***")
  NSNotificationCenter.defaultCenter.postNotificationName("ASDBeanLightClear", object:self)
end


  ## Data Loading
  #def bestStatusForPerson(person)
  #  bestStatus = IMPersonStatusOffline # Let's assume they're offline to start
  #  IMService.allServices.each do |service|
  #    snames = service.screenNamesForPerson(person)
  #    if snames
  #      snames.each do |screenName|
  #        dict = service.infoForScreenName(screenName)
  #        next if dict.nil?
  #        status = dict[IMPersonStatusKey]
  #        next if status.nil?
  #        thisStatus = status.intValue
  #        if thisStatus > bestStatus
  #          bestStatus = thisStatus
  #        end
  #      end
  #    end
  #  end
  #  bestStatus
  #end
  #
  ## This dumps all the status information and rebuilds the array against the current @abPeople
  ## Fairly expensive, so this is only done when necessary
  #def rebuildStatusInformation
  #  @imPersonStatus = @abPeople.map { |person| bestStatusForPerson(person) }
  #  @table.reloadData
  #end
  #
  ## Rebuild status information for a given person, much faster than a full rebuild
  #def rebuildStatusInformationForPerson(forPerson)
  #  @abPeople.each_with_index do |person, i|
  #    next unless person == forPerson
  #    @imPersonStatus[i] = bestStatusForPerson(person)
  #  end
  #  @table.reloadData
  #end
  #
  ## This will do a full flush of people in our AB Cache, along with rebuilding their status
  #def reloadABPeople
  #  @abPeople = ABAddressBook.sharedAddressBook.people.sort do |x, y|
  #    x.displayName <=> y.displayName
  #  end
  #  rebuildStatusInformation
  #end
  #
  ## NSTableViewDataSource protocol.
  #
  #def numberOfRowsInTableView(tableView)
  #  @abPeople ? @abPeople.size : 0
  #end
  #
  #def tableView(tableView, objectValueForTableColumn:tableColumn, row:row)
  #  case tableColumn.identifier
  #    when 'status'
  #      status = @imPersonStatus[row]
  #      NSImage.imageNamed IMService.imageNameForStatus(status)
  #    when 'name'
  #      @abPeople[row].displayName
  #  end
  #end

end
