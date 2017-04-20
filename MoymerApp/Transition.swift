//
//  Transition.swift
//  MoymerApp
//
//  Created by Pedro on 20/04/17.
//  Copyright © 2017 Pedro. All rights reserved.
//

import UIKit


class Transition: NSObject {
    
    
    var circle = UIView()
    
    var startingPoint = CGPoint.zero {
        didSet {
            circle.center = startingPoint
        }
        
    }
    
    var circleColor = UIColor.white
    
    var duration = 0.6
    
    enum TransitionMode : Int {
        case present, dismiss, pop
    }
    
    var transitionMode : TransitionMode = .present
    
    var image = UIImageView()
    
}


extension Transition : UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        if transitionMode == .present {
            if let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = presentedView.center
                let viewSize = presentedView.frame.size
                
                circle = UIView()
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: self.startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                circle.backgroundColor = UIColor.blue
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                containerView.addSubview(circle)
                
                presentedView.center = startingPoint
                presentedView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                presentedView.alpha = 0
                
                presentedView.backgroundColor = UIColor.white
                
                let image = UIImageView(frame: CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
                image.image = informationsDAO.sharedInstance.getVideoInfo(index: informationsDAO.sharedInstance.getCellSelected()).thumb
                image.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                image.tag = 5
                
                presentedView.addSubview(image)
                
                containerView.addSubview(presentedView)
                
                
                
                UIView.animate(withDuration: duration, animations: {
                    //self.circle.transform = CGAffineTransform.identity
                    presentedView.transform = CGAffineTransform.identity
                    presentedView.alpha = 1
                    image.transform = CGAffineTransform.identity
                    presentedView.center = viewCenter
                    
                }, completion: { (sucess:Bool) in
                    image.alpha = 0
                    transitionContext.completeTransition(sucess)
                })
                
            }
            
        } else {
            
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returningView = transitionContext.view(forKey: transitionModeKey) {
                
                let viewCenter = returningView.center
                let viewSize = returningView.frame.size
                
                circle.frame = frameForCircle(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.height / 2
                circle.center = startingPoint
                
                UIView.animate(withDuration: duration, animations: {
                    //self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returningView.center = self.startingPoint
                    returningView.alpha = 0
                    
                    if self.transitionMode == .pop {
                        containerView.insertSubview(returningView, belowSubview: returningView)
                        containerView.insertSubview(self.circle, belowSubview: returningView)
                        
                    }
                    
                    
                    
                }, completion: { (sucess:Bool) in
                    
                    returningView.center = viewCenter
                    returningView.removeFromSuperview()
                    //self.image.removeFromSuperview()
                    self.circle.removeFromSuperview()
                    transitionContext.completeTransition(sucess)
                    
                })
                
            }
            
        }
        
        
        
        
        
    }
    
    func removeImageView() {
        image.removeFromSuperview()
    }
    
    
    func frameForCircle(withViewCenter viewCenter:CGPoint, size viewSize : CGSize, startPoint : CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offsetVector = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offsetVector, height: offsetVector)
        
        return CGRect(origin: CGPoint.zero, size: size)
        
    }
    
}
