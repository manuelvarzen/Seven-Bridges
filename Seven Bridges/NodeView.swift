//
//  NodeView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

@IBDesignable class NodeView: UIView {
    
    // Width of the Node's border
    @IBInspectable var lineWidth = CGFloat(4)
    
    // Color of the Node's center
    @IBInspectable var fillColor = UIColor.lightGray
    
    // Color of the Node's border
    @IBInspectable var strokeColor = UIColor.gray
    
    // Label for the Node
    @IBInspectable var label: String?
    
    init(color: UIColor = UIColor.gray, at location: CGPoint) {
        super.init(frame: CGRect(x: location.x-24, y: location.y-24, width: 48, height: 48))
        
        fillColor = color.withAlphaComponent(0.5)
        strokeColor = color
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = CGSize(width: 48, height: 48)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect.insetBy(dx: lineWidth/2, dy: lineWidth/2))
        path.lineWidth = lineWidth
        
        fillColor.setFill()
        path.fill()
        
        strokeColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.superview as! GraphView).isInEditMode {
            self.superview?.bringSubview(toFront: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.superview as! GraphView).isInEditMode {
            for touch in touches {
                let location = touch.location(in: self)
                let previousLocation = touch.previousLocation(in: self)
                
                self.frame = self.frame.offsetBy(dx: (location.x - previousLocation.x), dy: (location.y - previousLocation.y))
            }
        }
    }
 
}
