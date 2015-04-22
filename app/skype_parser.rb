class SkypeParser



    def parse(response)
      @event = nil
      response.each_line do |line|
        case line
        when /CALL\s(\d*)\sSTATUS\s(\w*)/
            @event = Regexp.last_match(2).lowercaseString
        when /CALL\s(\d*)\sDURATION\s(\d*)/
            @event = "duration"
        end
        if @event
          status_event = NSNotification.notificationWithName("BBSkypeStatusNotification", object:self, userInfo:{"status" => @event})
          NSNotificationCenter.defaultCenter.postNotification(status_event)
        end
      end
    end


end
