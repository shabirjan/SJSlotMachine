# SJSlotMachine
Swift Version of ZCSlotMachine

### Requirements
---
* **iOS 5** or later
* QuartzCore.framework
* **ARC**

### How To Use
---

SJSlotMachine is a subclass of UIView. The demo application shows how it is used.

```
 _slotMachine = SJSlotMachine(frame: CGRect(x: 0, y: 0, width: 291, height: 193))
 _slotMachine.center = CGPoint(x: self.view.frame.size.width/2, y: 120)
 _slotMachine.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin]
 _slotMachine.contentInset = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
 _slotMachine.backgroundImage = UIImage(named: "SlotMachineBackground")
 _slotMachine.coverImage = UIImage(named: "SlotMachineCover")
        
 _slotMachine.delegate = self
 _slotMachine.dataSource = self
        
 self.view.addSubview(_slotMachine)
    
```

And implement the SJSlotMachineDataSource protocol.

```
func iconsForSlots(in slotMachine: SJSlotMachine) -> [UIImage] {
    return _slotsIcons
}
func numberOfSlots(in slotMachine: SJSlotMachine) -> Int {
    return 4
}
func slotWidth(in slotMachine: SJSlotMachine) -> CGFloat {
    return 65.0
}
func slotSpacing(in slotMachine: SJSlotMachine) -> CGFloat {
    return 5.0
}

```

And finally get the slot machine started.

```
[_slotMachine startSliding];
```

### Credits
---
The avatar icons used in the demo app was designed by [风尾竹](http://www.booui.com). You should ask for authorization if you want to use it in your project. 

SJSlotMachine is the Swift Version of : ZCSlotMachine (https://github.com/iamzcc/ZCSlotMachine)
