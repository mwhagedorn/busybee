# busybee
rubymotion app to interact with skype, Lync and an Arduino device to turn on a red light.

The problem:  I am a teleworker with small children
The solution:  turn on a red light whenever I am on the phone, in a teleconference.

Should be pluggable
  Skype
  Lync
  G+ hangouts


Light Blue Bean is the current target, its got a LED that can be red, green, etc.  It connects via BlueTooth LE.
https://punchthrough.com/bean/

# bundle exec rake  to build and run

#TODO   runtime cant find the state machine
#TODO   FSM for skype not firing
#TODO   Move FSM code to external class (started)
#TODO   implement handle_on_the_phone/handle_not_on_the_phone. Now its a noop
