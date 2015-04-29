class SkypeFSM

  attr_accessor :fsm

  def initialize
    @fsm = StateMachine::Base.new start_state: :off_phone, verbose: true


    @fsm.when :off_phone do |state|
      state.on_entry { NSLog "I'm available, started and alive!" }
      state.transition_to :busy,
                          on: :unplaced,
                          action: proc { NSLog("unplaced event"); handle_on_the_phone }
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

  def handle_on_the_phone
    NSLog("***Send LED on***")
    NSNotificationCenter.defaultCenter.postNotificationName("ASDBeanLightRed", object: self)
  end

  def handle_not_on_the_phone
    NSLog("***Send LED off***")
    NSNotificationCenter.defaultCenter.postNotificationName("ASDBeanLightClear", object: self)
  end


end