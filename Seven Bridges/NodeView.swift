//
//  NodeView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

@IBDesignable class NodeView: UIView {
    
    // Diameter of the node
    static let diameter: CGFloat = 36
    
    // Radius of the node, computed as half the diameter
    static let radius: CGFloat = diameter / 2
    
    // Edges connected to the node
    var edges = [EdgeView]()
    
    // Width of the node's border
    @IBInspectable var lineWidth = CGFloat(4)
    
    // Previous color of the node's center
    @IBInspectable var previousfillColor: UIColor?
    
    // Color of the node's border
    @IBInspectable var strokeColor = UIColor.gray
    
    // Color of the node's center
    @IBInspectable var fillColor = UIColor.lightGray
    
    // Label for the node
    @IBInspectable var label: String?
    
    init(color: UIColor = UIColor.gray, at location: CGPoint) {
        super.init(frame: CGRect(x: location.x - NodeView.radius, y: location.y - NodeView.radius, width: NodeView.diameter, height: NodeView.diameter))
        
        strokeColor = color
        fillColor = strokeColor
        
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = CGSize(width: NodeView.diameter, height: NodeView.diameter)
        
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
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
        guard (superview as! GraphView).isInEditMode else { return }
        
        // bring selected node to front
        superview?.bringSubview(toFront: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // select node if graph is making edges
        let graphView = (superview as! GraphView)
        
        guard graphView.isInEditMode && graphView.isMakingEdges else { return }
        
        guard graphView.selectedNodeToMakeEdge != nil else {
            graphView.selectedNodeToMakeEdge = self
            
            return
        }
        
        graphView.makeEdge(to: self)
        
        // TODO: long press gives option to delete node or give node a label
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let graphView = (superview as! GraphView)
        guard graphView.isInEditMode && !graphView.isMakingEdges else { return }
        
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            frame = frame.offsetBy(dx: (location.x - previousLocation.x), dy: (location.y - previousLocation.y))
        }
        
        // TODO: update size and origin of connected edges
        for edge in edges {
            edge.updateSize()
            edge.updateOrigin()
            edge.updatePath()
            edge.setNeedsDisplay()
        }
    }
 
}
