## Today

## On Deck
- [ ] **Mock Up**. Use sketch to make some HiFi mockup alternatives. Get that extra boost of inspiration from a pretty end goal.
- [ ] **Timestamp** the ring moment and show time as distance to that instant.
- [ ] **Schedule** the ring so it can work in the background.
- [ ] Don't ring when you drag it to zero yourself
- [ ] **Forshadow**. Show urgency by changing color on a scale from set time (not total time) to 0

## Someday, Over the Rainbow
- [ ] **Snap on Tap** into common times like 1, 5, 10, 15, 30, 60
- [ ] **Curve Time**. Don't scale the time linearly (1 and 5 and 10 need lots of visual room, later times don't)
- [ ] **Teach** the user that there is a timer there by animating it on app launch
- [ ] **Sinebow** for beautiful colors
- [ ] **Redesign** timer bar to emphasise a few remaining mins (angled? gradient? color change? graduated bars?)
- [ ] **Follow** the user's finger around while they are dragging the time set
- [ ] **Refactor** the timer rect into a UIControl: http://www.objc.io/issue-3/custom-controls.html

## Questions
* If `typealias SystemSoundID = UInt32` Why is `Int` not convertable to a `SystemSoundID`?
* Can I play sounds that are on the device already?

## Done
- [x] **Time**. Fix the timing to always show the seconds count correctly
- [x] **Physical**. Get a feeling of momentum and physicality while dragging.
- [x] **Beat** the flash to the sound of the alarm (issue with audioPlayer ref)
- [x] **Ring** a beautiful chime when done
- [x] **Flash** the screen when timer completes
- [x] Fix issues from Swift language changes