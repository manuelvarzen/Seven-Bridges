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
    var edges = [Edge]()
    
    // All nodes that are adjacent.
    var neighbors: [Node] {
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
    
    var highlightColor = UIColor.black
    
    var isHighlighted: Bool = false {
        didSet {
            if self.isHighlighted {
                color = highlightColor
            } else {
                color = previousFillColor
            }
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            if self.isSelected {
                fillColor = UIColor.white
                label.textColor = previousFillColor
            } else {
                fillColor = previousFillColor
                label.textColor = UIColor.white
            }
        }
    }
    
    // Previous color of the node's center.
    var previousFillColor: UIColor!
    
    // Previous color of the node's border.
    var previousStrokeColor: UIColor!
    
    // Color of the node's border. Changing its value saves the previous color.
    var strokeColor: UIColor! {
        willSet {
            previousStrokeColor = self.strokeColor
        }
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Color of the node's center. Changing its value saves the previous color.
    var fillColor: UIColor! {
        willSet {
            previousFillColor = self.fillColor
        }
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Unified color of the node's fill and border.
    var color: UIColor! {
        didSet {
            strokeColor = self.color
            fillColor = self.color
            
            setNeedsDisplay()
        }
    }
    
    // Label for the node.
    var label = UILabel()
    
    init(color: UIColor = UIColor.lightGray, at location: CGPoint) {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size = CGSize(width: Node.diameter, height: Node.diameter)
        
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
    }
    
    // Determines whether a given node is adjacent.
    func isAdjacent(to node: Node) -> Bool {
        if neighbors.contains(node) {
            return true
        } else {
            return false
        }
    }
    
    // Determines the shortest path between this node and the given node. If the path doesn't exist or the target is the origin, the method returns an empty array.
    func shortestPath(to target: Node, shortestPath: [Node] = [Node]()) -> [Node]? {
        var path = shortestPath
        path.append(self)
        
        if target == self {
            return path
        }
        
        let graph = superview as! Graph
        
        var shortest: [Node]?
        
        for node in graph.matrixForm[self]! {
            if !path.contains(node!) {
                let newPath = node?.shortestPath(to: target, shortestPath: path)
                
                if newPath != nil {
                    if shortest == nil || (newPath?.count)! < (shortest?.count)! {
                        shortest = newPath
                    }
                }
            }
        }
        
        return shortest
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
        let graphView = (superview as! Graph)
        guard graphView.mode == .dragging || graphView.mode == .selecting else { return }
        
        // TODO: Bring connected edges to front (of edges).
        
        // Bring touched node to front.
        superview?.bringSubview(toFront: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let graphView = (superview as! Graph)
        
        if graphView.mode == .edges {
            // Select this node as a start node for a new edge if the selected node is nil.
            if graphView.selectedNodeToMakeEdge == nil {
                graphView.makeEdge(from: self)
            } else {
                graphView.makeEdge(to: self)
            }
        }
        
        if graphView.mode == .selecting {
            graphView.selectNode(self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let graphView = (superview as! Graph)
        
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
