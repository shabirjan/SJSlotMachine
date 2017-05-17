//
//  ZCSlotMzachine.swift
//  SJSlotMachineSwift
//
//  Created by Shabir Jan on 5/17/17.
//  Copyright © 2017 Shabir Jan. All rights reserved.
//

import UIKit
import QuartzCore

// MARK: SJSlotMachine Delegate
protocol SJSlotMachineDelegate: NSObjectProtocol {
    func slotMachineWillStartSliding(_ slotMachine: SJSlotMachine)
    func slotMachineDidEndSliding(_ slotMachine: SJSlotMachine)
}

@objc protocol SJSlotMachineDataSource: NSObjectProtocol {
    func numberOfSlots(in slotMachine: SJSlotMachine) -> Int
    func iconsForSlots(in slotMachine: SJSlotMachine) -> [UIImage]
    @objc optional  func slotWidth(in slotMachine: SJSlotMachine) -> CGFloat
    @objc optional func slotSpacing(in slotMachine: SJSlotMachine) -> CGFloat
}

// MARK: SJSlotMachine
class SJSlotMachine: UIView {
    /****** UI Properties ******/
    public var contentInset: UIEdgeInsets {
        set(new) {
            _contentInset = new
            
            let viewFrame = self.frame
            _contentView?.frame = CGRect(x: _contentInset.left, y: _contentInset.top, width: viewFrame.size.width - _contentInset.left - _contentInset.right, height: viewFrame.size.height - _contentInset.top - _contentInset.bottom)
        }
        get {
            return _contentInset
        }
    }
    public var backgroundImage: UIImage? {
        didSet {
            _backgroundImageView?.image = backgroundImage
        }
    }
    public var coverImage: UIImage? {
        didSet {
            _coverImageView?.image = coverImage
        }
    }
    /****** Data Properties ******/
    public var slotResults: [Int] {
        get {
            return _slotResults
        }
        set(new) {
            if !isSliding {
                _slotResults = new
                
                if _currentSlotResults.count == 0  {
                    var currentSlotResults = [Int]()
                    for _ in slotResults {
                        currentSlotResults.append(Int(0))
                    }
                    _currentSlotResults = currentSlotResults
                }
            }
        }
    }
    /****** Animation ******/
    
    // You can use this property to control the spinning speed, default to 0.14f
    public var singleUnitDuration: CGFloat = 0.0
    public weak var delegate: SJSlotMachineDelegate?
    public  weak var dataSource: SJSlotMachineDataSource? {
        didSet{
            _dataSource = dataSource
            reloadData()
        }
        
    }
    
    //Private
    
    var _backgroundImageView: UIImageView?
    var _coverImageView: UIImageView?
    var _contentView: UIView?
    var _contentInset = UIEdgeInsets()
    var _slotScrollLayerArray = [CALayer]()
    
    // Data
    var _slotResults = [Int]()
    var _currentSlotResults = [Int]()
    weak var _dataSource: SJSlotMachineDataSource?
    
    let SHOW_BORDER = 0
    var isSliding: Bool = false
    let kMinTurn: Int = 3
    
    // MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        _backgroundImageView  = UIImageView(frame: frame)
        _backgroundImageView?.contentMode = .center
        self.addSubview(_backgroundImageView!)
        
        _contentView = UIView(frame: frame)
        _contentView?.layer.borderColor = UIColor.blue.cgColor
        _contentView?.layer.borderWidth = 1
        self.addSubview(_contentView!)
        
        _coverImageView = UIImageView(frame: frame)
        _coverImageView?.contentMode = .center
        self.addSubview(_coverImageView!)
        
        _slotScrollLayerArray = [CALayer]()
        singleUnitDuration = 0.14
        
        _contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadData() {
        if dataSource != nil {
            if _contentView?.layer.sublayers != nil{
                for containerLayer in (_contentView?.layer.sublayers)! {
                    containerLayer.removeFromSuperlayer()
                }
            }
            _slotScrollLayerArray = [CALayer]()
            
            let numberOfSlots: Int = (dataSource?.numberOfSlots(in: self))! as Int
            let slotSpacing: CGFloat =  (dataSource?.slotSpacing!(in: self))!
            
            var slotWidth = (_contentView?.frame.size.width)! / CGFloat ( numberOfSlots)
            slotWidth = (dataSource?.slotWidth!(in: self))!
            
            for i in 0..<numberOfSlots {
                let slotContainerLayer = CALayer.init()
                slotContainerLayer.frame = CGRect(x:CGFloat (i) * (slotWidth + slotSpacing), y: 0, width: slotWidth, height: (_contentView?.frame.size.height)!)
                slotContainerLayer.masksToBounds = true
                
                let slotScrollLayer = CALayer.init()
                slotScrollLayer.frame = CGRect(x: 0, y: 0, width: slotWidth, height: (_contentView?.frame.size.height)!)
                slotScrollLayer.borderColor = UIColor.green.cgColor
                slotScrollLayer.borderWidth = 1
                
                slotContainerLayer.addSublayer(slotScrollLayer)
                _contentView?.layer.addSublayer(slotContainerLayer)
                _slotScrollLayerArray.append(slotScrollLayer)
                
            }
            
            let singleUnitHeight: CGFloat = (_contentView?.frame.size.height)! / 3
            let slotIcons:[UIImage] = (dataSource?.iconsForSlots(in: self))!
            let iconCount = slotIcons.count
            
            for i in 0..<numberOfSlots {
                let slotScrollLayer: CALayer = (_slotScrollLayerArray[i])
                let scrollLayerTopIndex = -(i + kMinTurn  + 3) * iconCount
                
                for j in (scrollLayerTopIndex...0).reversed() {
                    let iconImage: UIImage = slotIcons[abs(j % iconCount)]
                    let iconImageLayer = CALayer.init()
                    let offsetYUnit =  j + 1 + iconCount
                    iconImageLayer.frame = CGRect(x: 0, y: (CGFloat(offsetYUnit) * singleUnitHeight), width: slotScrollLayer.frame.size.width, height: singleUnitHeight)
                    iconImageLayer.contents = iconImage.cgImage
                    iconImageLayer.contentsScale = iconImage.scale
                    iconImageLayer.contentsGravity = kCAGravityCenter
                    
                    iconImageLayer.borderColor = UIColor.red.cgColor
                    iconImageLayer.borderWidth = 1
                    
                    slotScrollLayer.addSublayer(iconImageLayer)
                }
            }
            
        }
    }
    
    //MARK : - Public Methods
    func startSliding() {
        if isSliding {
            return
        }
        else {
            isSliding = true
            delegate?.slotMachineWillStartSliding(self)
        }
        
        let slotIcons:[UIImage] = (self.dataSource?.iconsForSlots(in: self))!
        let iconCount = slotIcons.count
        var completePositionArray = [Any]()
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut))
        CATransaction.setDisableActions(true)
        CATransaction.setCompletionBlock {
            self.isSliding = false
            self.delegate?.slotMachineDidEndSliding(self)
            
            for i in 0..<self._slotScrollLayerArray.count {
                let slotScrollLayer:CALayer = self._slotScrollLayerArray[i]
                slotScrollLayer.position = CGPoint(x: CGFloat(slotScrollLayer.position.x), y: CGFloat(CFloat((completePositionArray[i] as? NSNumber)!)))
                
                var toBeDeletedLayerArray = [CALayer]()
                
                let resultIndex = Int((self.slotResults[i]))
                let currentIndex = Int((self._currentSlotResults[i]))
                
                for j in 0..<(iconCount * (self.kMinTurn + i) + resultIndex - currentIndex) {
                    let iconLayer: CALayer = (slotScrollLayer.sublayers?[j])!
                    toBeDeletedLayerArray.append(iconLayer)
                }
                for toBeDeletedLayer in toBeDeletedLayerArray {
                    let toBeAddedLayer = CALayer()
                    toBeAddedLayer.frame = toBeDeletedLayer.frame
                    toBeAddedLayer.contents = toBeDeletedLayer.contents;
                    toBeAddedLayer.contentsScale = toBeDeletedLayer.contentsScale;
                    toBeAddedLayer.contentsGravity = toBeDeletedLayer.contentsGravity;
                    
                    let shiftY = CGFloat(iconCount) * toBeAddedLayer.frame.size.height * CGFloat((self.kMinTurn + i + 3))
                    toBeAddedLayer.position = CGPoint(x: toBeAddedLayer.position.x, y: toBeAddedLayer.position.y - shiftY)
                    
                    toBeDeletedLayer.removeFromSuperlayer()
                    slotScrollLayer.addSublayer(toBeAddedLayer)
                }
                toBeDeletedLayerArray = [CALayer]()
            }
            self._currentSlotResults = self.slotResults
            completePositionArray = [Any]()
        }
        
        let keyPath: String = "position.y"
        
        for i in 0..<_slotScrollLayerArray.count {
            let slotScrollLayer : CALayer = _slotScrollLayerArray[i]
            let resultIndex = Int((slotResults[i] ))
            let currentIndex = Int((_currentSlotResults[i] ))
            let howManyUnit: Int = (i + kMinTurn) * iconCount + resultIndex - currentIndex
           
            let slideY: CGFloat = CGFloat(howManyUnit) * (_contentView!.frame.size.height / 3)
            
            let slideAnimation = CABasicAnimation(keyPath: keyPath)
            slideAnimation.fillMode = kCAFillModeForwards
            slideAnimation.duration = CFTimeInterval(CGFloat(15) * self.singleUnitDuration)
            slideAnimation.toValue = Int(slotScrollLayer.position.y + slideY)
            slideAnimation.isRemovedOnCompletion = false
            
            slotScrollLayer.add(slideAnimation, forKey: "slideAnimation")
            completePositionArray.append(slideAnimation.toValue!)
        }
        
        
        CATransaction.commit()
    }
    
}
