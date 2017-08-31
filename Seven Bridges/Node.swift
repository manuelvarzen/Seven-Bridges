//
//  NodeView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

@IBDesignable class Node: UIView {
    
    // Diameter of the node.
    static let diameter: CGFloat = 48
    
    // Radius of the node, computed as half the diameter.
    static let radius: CGFloat = diameter / 2
    
    // Edges connected to the node.
    var edges = Set<Edge>()
    
    // All nodes that are connected to this node.
    var connections: [Node] {
        get {
            var results = [Node]()
            
            for edge in edges {
                if edge.startNode! != self {
                    results.append(edge.startNode!)
                } else if edge.endNode! != self {
                    results.append(edge.endNode!)
                }
            }
            
            return results
        }
    }
    
    // Width of the node's border.
    var lineWidth: CGFloat = diameter / 6
    
    private let highlightColor = UIColor.black
    
    var isHighlighted: Bool = false {
        didSet {
            if self.isHighlighted {
                color = highlightColor
            } else {
                color = initialColor
            }
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            if self.isSelected {
                fillColor = UIColor.white
                label.textColor = initialColor
            } else {
                fillColor = initialColor
                label.textColor = UIColor.white
            }
        }
    }
    
    // Color that the node is initialized with.
    private let initialColor: UIColor
    
    // Color of the node's border stroke.
    var strokeColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Color of the node's center fill.
    var fillColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Unified color of the node's fill and border.
    var color: UIColor! {
        didSet {
            strokeColor = self.color
            fillColor = self.color
        }
    }
    
    // Label for the node.
    var label = UILabel()
    
    private var isBeingDragged = false
    
    override var description: String {
        get {
            if let number = label.text {
                return number
            } else {
                return "Unknown Node"
            }
        }
    }
    
    init(color: UIColor = UIColor.lightGray, at location: CGPoint) {
        initialColor = color
        
        super.init(frame: CGRect(x: location.x - Node.radius, y: location.y - Node.radius, width: Node.diameter, height: Node.diameter))
        
        // Set the colors.
        self.color = color
        
        strokeColor = self.color
        
        fillColor = self.color
        
        // Set up the label.
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        
        // Enable user interaction.
        isUserInteractionEnabled = true
        
        // Set background color to clear.
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        initialColor = UIColor.lightGray
        
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
    }
    
    // Determines whether a given node is connected to this node.
    func isConnected(to node: Node) -> Bool {
        if connections.contains(node) {
            return true
        } else {
            return false
        }
    }
    
    // Determines whether a given node is adjacent to this node.
    func isAdjacent(to node: Node) -> Bool {
        for edge in edges {
            if edge.startNode! == node || edge.endNode! == node {
                return true
            }
        }
        
        return false
    }
    
    func highlight(delay: Int = 0, duration: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(delay), execute: {
            self.isHighlighted = true
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(duration), execute: {
            self.isHighlighted = false
        })
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect.insetBy(dx: lineWidth/2, dy: lineWidth/2))
        path.lineWidth = lineWidth
        
        fillColor.setFill()
        path.fill()
        
        strokeColor.setStroke()
        path.stroke()
        
        label.drawText(in: rect)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: Bring connected edges to front (of edges).
        
        // Bring touched node to front.
        superview?.bringSubview(toFront: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isBeingDragged else {
            isBeingDragged = false
            return
        }
        
        let graph = superview as! Graph
        
        if graph.mode == .edges {
            // Select this node as a start node for a new edge if the selected node is nil.
            if graph.selectedNodes.isEmpty {
                graph.makeEdge(from: self)
            } else {
                graph.makeEdge(to: self)
            }
            
            return
        }
        
        if graph.mode == .select {
            graph.selectNode(self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            isBeingDragged = true
            
            frame = frame.offsetBy(dx: (location.x - previousLocation.x), dy: (location.y - previousLocation.y))
        }
        
        // Update size and origin of connected edges to move with node.
        for edge in edges {
            edge.followConnectedNodes()
        }
    }
    
    
 
}
