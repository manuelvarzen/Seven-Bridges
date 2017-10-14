//
//  NodeView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

@IBDesignable class Node: UIView {
    
    /// Diameter of the node.
    static let diameter: CGFloat = 48
    
    /// Radius of the node, computed as half the diameter.
    static let radius: CGFloat = diameter / 2
    
    /// Edges connected to the node.
    var edges = Set<Edge>()
    
    /// All nodes that are connected to this node.
    var adjacentNodes: Set<Node> {
        get {
            var results = Set<Node>()
            
            for edge in edges {
                if edge.startNode! != self {
                    results.insert(edge.startNode!)
                } else if edge.endNode! != self {
                    results.insert(edge.endNode!)
                }
            }
            
            return results
        }
    }
    
    // Width of the node's border.
    static var lineWidth: CGFloat = diameter / 6
    
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
                return "Node \(number)"
            } else {
                return "Unknown Node"
            }
        }
    }
    
    init(color: UIColor = UIColor.lightGray, at location: CGPoint) {
        initialColor = color
        
        super.init(frame: CGRect(x: location.x - Node.radius, y: location.y - Node.radius, width: Node.diameter, height: Node.diameter))
        
        // set the colors
        self.color = color
        strokeColor = self.color
        fillColor = self.color
        
        // set up the label
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = NSTextAlignment.center
        
        // enable user interaction
        isUserInteractionEnabled = true
        
        // set background color to clear
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        initialColor = UIColor.lightGray
        
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
    }
    
    /// Determines whether a given node is adjacent to this node.
    ///
    /// - parameter to: The node to test whether it is adjacent.
    func isAdjacent(to node: Node) -> Bool {
        if adjacentNodes.contains(node) {
            return true
        } else {
            return false
        }
    }
    
    /// Returns an edge connecting this node to a given node.
    ///
    /// - parameter node: An adjacent node.
    func getEdge(to node: Node, directed: Bool = false) -> Edge? {
        for edge in edges {
            if edge.startNode! == self && edge.endNode! == node {
                return edge
            }
            
            if !directed && edge.endNode! == self && edge.startNode! == node {
                return edge
            }
        }
        
        return nil
    }
    
    /// Finds the edge with the lowest weight connected to the node.
    ///
    /// - parameter directed: Whether finding the cheapest edge should account for a directed graph.
    func cheapestEdge(directed: Bool = false) -> Edge? {
        if edges.isEmpty {
            return nil
        }
        
        var cheapest: Edge? = edges.first
        for edge in edges {
            if directed && edge.endNode == self {
                continue
            }
            
            if edge.weight < cheapest!.weight {
                cheapest = edge
            }
        }
        
        return cheapest
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect.insetBy(dx: Node.lineWidth / 2, dy: Node.lineWidth / 2))
        path.lineWidth = Node.lineWidth
        
        fillColor.setFill()
        path.fill()
        
        strokeColor.setStroke()
        path.stroke()
        
        label.drawText(in: rect)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // TODO: bring connected edges to front (of edges)
        
        // bring touched node to front
        superview?.bringSubview(toFront: self)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !isBeingDragged else {
            isBeingDragged = false
            return
        }
        
        let graph = superview as! Graph
        
        if graph.mode == .edges {
            // select this node as a start node for a new edge if the selected node is nil
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
        guard (superview as! Graph).mode != .view else { return } // if in view mode, do not allow dragging
        
        for touch in touches {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            
            isBeingDragged = true
            
            frame = frame.offsetBy(dx: (location.x - previousLocation.x), dy: (location.y - previousLocation.y))
        }
        
        // update size and origin of connected edges to move with node
        for edge in edges {
            edge.followConnectedNodes()
        }
    }
    
    
 
}
