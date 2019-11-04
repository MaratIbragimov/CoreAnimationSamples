//
//  ViewController.swift
//  GradientLayer
//
//  Created by Marat Ibragimov on 04/11/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit

class SkeletonViewController: UIViewController {

       
    @IBOutlet weak var skeletonView: SkeletonView!
    override func viewDidLoad() {
        super.viewDidLoad()

        skeletonView.startAnimations()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        skeletonView.layer.cornerRadius = skeletonView.frame.width / 2
    }

    @IBAction func didTapAnimateGradient(_ sender: Any) {
       // skeletonLayer.startAnimations()
    }
    
}


class SkeletonView: UIView {
   let skeletonLayer = SkeletonLayer()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.layer.masksToBounds = true
        self.layer.addSublayer(skeletonLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        skeletonLayer.frame = self.bounds
    }
    
    func startAnimations() {
        skeletonLayer.startAnimations()
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        skeletonLayer.stopAnimation()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if skeletonLayer.animationIsRunning == false {
            skeletonLayer.startAnimations()
        }
    }
}

@IBDesignable
class SkeletonLayer: CAGradientLayer {
    let gradientBackgroundColor : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    let gradientMovingColor : CGColor = UIColor(white: 0.90, alpha: 1.0).cgColor
    let startLocations : [NSNumber] = [-1.0,-0.5, 0.0]
    let endLocations : [NSNumber] = [1.0,1.5, 2.0]
    let movingAnimationDuration : CFTimeInterval = 1
    let delayBetweenAnimationLoops : CFTimeInterval = 0.5
    var animationIsRunning = false
    override init() {
        super.init()
        self.colors = [ gradientBackgroundColor ,gradientMovingColor, gradientBackgroundColor]
        self.startPoint = CGPoint(x: 0.5, y: 0.0)
        self.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.locations = startLocations
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimations() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = self.startLocations
        animation.toValue = self.endLocations
        animation.duration = self.movingAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = self.movingAnimationDuration + self.delayBetweenAnimationLoops
        animationGroup.animations = [animation]
        animationGroup.repeatCount = .infinity
        self.add(animationGroup, forKey: animation.keyPath)
        animationIsRunning = true
    }
    
    func stopAnimation() {
        self.removeAllAnimations()
        animationIsRunning = false
    }
}
