//
//  ViewController.swift
//  ZCSlotMachineSwift
//
//  Created by Shabir Jan on 5/17/17.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var _slotMachine = SJSlotMachine()
    var _slotContainerView = UIView()
    var _startButton: UIButton?
    
    var _slotOneImageView: UIImageView?
    var _slotTwoImageView: UIImageView?
    var _slotThreeImageView: UIImageView?
    var _slotFourImageView: UIImageView?
    var _slotsIcons = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        _slotsIcons = [UIImage(named: "Doraemon")!, UIImage(named: "Mario")!, UIImage(named: "Nobi Nobita")!, UIImage(named: "Batman")!]
        
        _slotMachine = SJSlotMachine(frame: CGRect(x: 0, y: 0, width: 291, height: 193))
        _slotMachine.center = CGPoint(x: self.view.frame.size.width/2, y: 120)
        _slotMachine.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin]
        _slotMachine.contentInset = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        _slotMachine.backgroundImage = UIImage(named: "SlotMachineBackground")
        _slotMachine.coverImage = UIImage(named: "SlotMachineCover")
        
        _slotMachine.delegate = self
        _slotMachine.dataSource = self
        
        self.view.addSubview(_slotMachine)
        
        _startButton = UIButton(type: .custom)
        let btnImageN = UIImage(named: "StartBtn_N")
        let btnImageH = UIImage(named: "StartBtn_H")
        _startButton?.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat((btnImageN?.size.width)!), height: CGFloat((btnImageN?.size.height)!))
        _startButton?.center = CGPoint(x: CGFloat(view.frame.size.width / 2), y: CGFloat(270))
        _startButton?.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        _startButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(16.0))
        _startButton?.setBackgroundImage(btnImageN, for: .normal)
        _startButton?.setBackgroundImage(btnImageH, for: .highlighted)
        _startButton?.setTitle("Start", for: .normal)
        _startButton?.addTarget(self, action: #selector(self.start), for: .touchUpInside)
        view.addSubview(_startButton!)
        
        _slotContainerView = UIView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(180), height: CGFloat(45)))
        _slotContainerView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        _slotContainerView.center = CGPoint(x: CGFloat(view.frame.size.width / 2), y: CGFloat(350))
        view.addSubview(_slotContainerView)
        
        _slotOneImageView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(45), height: CGFloat(45)))
        _slotOneImageView?.contentMode = .center
        _slotTwoImageView = UIImageView(frame: CGRect(x: CGFloat(45), y: CGFloat(0), width: CGFloat(45), height: CGFloat(45)))
        _slotTwoImageView?.contentMode = .center
        _slotThreeImageView = UIImageView(frame: CGRect(x: CGFloat(90), y: CGFloat(0), width: CGFloat(45), height: CGFloat(45)))
        _slotThreeImageView?.contentMode = .center
        _slotFourImageView = UIImageView(frame: CGRect(x: CGFloat(135), y: CGFloat(0), width: CGFloat(45), height: CGFloat(45)))
        _slotFourImageView?.contentMode = .center
        _slotContainerView.addSubview(_slotOneImageView!)
        _slotContainerView.addSubview(_slotTwoImageView!)
        _slotContainerView.addSubview(_slotThreeImageView!)
        _slotContainerView.addSubview(_slotFourImageView!)
        
    }
    func start(){
        let slotIconCount: Int = _slotsIcons.count
        let slotOneIndex: Int = Int(arc4random_uniform(UInt32(slotIconCount)))
        let slotTwoIndex: Int = Int(arc4random_uniform(UInt32(slotIconCount)))
        let slotThreeIndex: Int = Int(arc4random_uniform(UInt32(slotIconCount)))
        let slotFourIndex: Int = Int(arc4random_uniform(UInt32(slotIconCount)))
        _slotOneImageView?.image = _slotsIcons[slotOneIndex]
        _slotTwoImageView?.image = _slotsIcons[slotTwoIndex]
        _slotThreeImageView?.image = _slotsIcons[slotThreeIndex]
        _slotFourImageView?.image = _slotsIcons[slotFourIndex]
        let slotArray = [Int(slotOneIndex), Int(slotTwoIndex), Int(slotThreeIndex), Int(slotFourIndex)]
        
        _slotMachine.slotResults = slotArray
        _slotMachine.startSliding()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
    }
}

extension ViewController : SJSlotMachineDelegate, SJSlotMachineDataSource{
    func slotMachineWillStartSliding(_ slotMachine: SJSlotMachine) {
        _startButton?.isEnabled = false
    }
    func slotMachineDidEndSliding(_ slotMachine: SJSlotMachine) {
        _startButton?.isEnabled = true
    }
    
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
    
    
}

