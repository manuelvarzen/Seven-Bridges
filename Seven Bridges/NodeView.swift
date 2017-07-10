//
//  NodeView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

@IBDesignable class NodeView: UIView {
    
    // Diameter of the node
    static let diameter: CGFloat = 42
    
    // Radius of the node, computed as half the diameter
    static let radius: CGFloat = diameter / 2
    
    // Edges connected to the node
    var edges = [EdgeView]()
    
    // Width of the node's border
    @IBInspectable var lineWidth: CGFloat = diameter / 6
    
    // Previous color of the node's center
    @IBInspectable var previousfillColor: UIColor!
    
    // Color of the node's border
    @IBInspectable var strokeColor: UIColor!
    
    // Color of the node's center
    @IBInspectable var fillColor: UIColor!
    
    // Label for the node
    var label = UILabel()
    
    init(color: UIColor = UIColor.lightGray, at location: CGPoint) {
        super.init(frame: CGRect(x: location.x - NodeView.radius, y: location.y - NodeView.radius, width: NodeView.diameter, height: NodeView.diameter))
        
        fillColor = color
        strokeColor = fillColor
        
        // FIXME:
        label.text = "TEST"
        label.frame.origin = self.frame.origin
        label.isEnabled = true
        label.isHidden = false
        
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
        guard (superview as! GraphView).mode == .dragging else { return }
        
        // TODO: Bring connected edges to front (of edges).
        
        // Bring touched node to front.
        superview?.bringSubview(toFront: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let graphView = (superview as! GraphView)
        
        // TODO: Replace double-tap with selection mode in the graph view.
        // Detect double-tap and prompt to rename the node.
        for touch in touches {
            if touch.tapCount == 2 {
                let alert = UIAlertController(title: "Rename Node?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addTextField(configurationHandler: nil)
                
                alert.addAction(UIAlertAction(title: "Rename", style: UIAlertActionStyle.default, handler: { a in
                    self.label.text = alert.textFields?[0].text!
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                
                let parentViewController = UIApplication.shared.windows[0].rootViewController
                parentViewController?.present(alert, animated: true, completion: nil)
            }
        }
        
        guard graphView.mode == .edges else { return }
        
        // Select this node as a start node for a new edge if the selected node is nil.
        if graphView.selectedNodeToMakeEdge == nil {
            graphView.makeEdge(from: self)
        } else {
            graphView.makeEdge(to: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let graphView = (superview as! GraphView)
        
        guard graphView.mode == .dragging else { return }
        
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            frame = frame.offsetBy(dx: (location.x - previousLocation.x), dy: (location.y - previousLocation.y))
        }
        
        // Update size and origin of connected edges to move with node.
        for edge in edges {
            edge.followConnectedNodes()
        }
    }
 
}
