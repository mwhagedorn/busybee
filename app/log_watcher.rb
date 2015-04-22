class LogWatcher

  def initialize
    #open file open("path....", O_RDONLY)
    #get global queue
    #dispatch source create
    @syslog = IO.sysopen("/var/log/system.log","r")
    @end = IO.open(@syslog)
    @end.seek(0, IO::SEEK_END)
    @gcdq = Dispatch::Queue.concurrent("com.appsdynamic.busybee.tasks")
    file_source_options = Dispatch::Source::VNODE_DELETE | Dispatch::Source::VNODE_WRITE  | Dispatch::Source::VNODE_EXTEND | Dispatch::Source::VNODE_ATTRIB | Dispatch::Source::VNODE_LINK   | Dispatch::Source::VNODE_RENAME | Dispatch::Source::VNODE_REVOKE
    @source = Dispatch::Source.new(Dispatch::Source::VNODE,@syslog,file_source_options, @gcdq ) do |s|
      if s.data | Dispatch::Source::VNODE_WRITE
        parse_data
      end
    #  self.parse_data(s.data)
    end




  end

  def parse_data
    @end.each_line do |line|
      case line
        when /Microsoft Lync\[\d*\]\:\sStatus\schanged\sto:\s(\w*)/
          send_notification_for_event( Regexp.last_match(1))
      end
    end
  end


  def send_notification_for_event(event)
    puts "sending event "+ event
    lync_status_event = NSNotification.notificationWithName("BBLyncStatusNotification", object:self, userInfo:{"status" => event})
    NSNotificationCenter.defaultCenter.postNotification(lync_status_event)
  end

end
