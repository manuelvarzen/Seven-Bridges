//
//  Edge.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

@IBDesignable class Edge: UIView {
    
    /// Thickness of the line.
    private let lineWidth: CGFloat = 4
    
    private var highlightColor: UIColor!
    
    /// Path of the line.
    private var path = UIBezierPath()
    
    /// Start point of the line.
    private var startPoint: CGPoint?
    
    /// End point of the line.
    private var endPoint: CGPoint?
    
    /// Node at beginning of edge.
    var startNode: Node!
    
    /// Node at end of edge.
    var endNode: Node!
    
    /// Weight of the edge.
    var weight = 1 {
        didSet {
            if self.isVisible {
                setNeedsDisplay()
            }
        }
    }
    
    /// Flow of the edge being used.
    var flow: Int? {
        didSet {
            if self.isVisible {
                setNeedsDisplay()
            }
        }
    }
    
    var reverseFlow: Int?
    
    /// Remaining capacity of the edge (weight - flow).
    var residualCapacity: Int? {
        if let f = flow {
            return weight - f
        } else {
            return nil
        }
    }
    
    /// Whether the edge appears highlighted.
    var isHighlighted: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isVisible: Bool {
        didSet {
            if self.isVisible {
                setNeedsDisplay()
            }
        }
    }
    
    override var description: String {
        let start = startNode.label.text!
        let end = endNode.label.text!
        
        return "\(start) → \(end)"
    }
    
    init(from startNode: Node, to endNode: Node, isVisible: Bool = true) {
        self.startNode = startNode
        self.endNode = endNode
        self.isVisible = isVisible
        
        super.init(frame: CGRect())
        
        // register edge with nodes
        startNode.edges.insert(self)
        endNode.edges.insert(self)
        
        if isVisible {
            updateSize()
            
            updateOrigin()
            
            backgroundColor = UIColor.clear
            
            clearsContextBeforeDrawing = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isVisible = true
        super.init(coder: aDecoder)
    }
    
    func highlight(_ enable: Bool = true, color: UIColor = UIColor.black) {
        if enable {
            highlightColor = color
            isHighlighted = true
        } else {
            isHighlighted = false
        }
    }
    
    func reversed(isVisible: Bool = false) -> Edge {
        let reversedEdge = Edge(from: self.endNode, to: self.startNode)
        reversedEdge.isVisible = isVisible
        reversedEdge.flow = flow
        
        return reversedEdge
    }
    
    /// Updates size, origin, and path of line relative to the start node and end node.
    func followConnectedNodes() {
        updateSize()
        updateOrigin()
        updatePath()
        setNeedsDisplay()
    }
    
    /// Updates size of the frame based on the distance between the start node and end node.
    private func updateSize() {
        // determine size of frame
        let width = abs(startNode!.frame.origin.x - endNode!.frame.origin.x) + Node.diameter
        let height = abs(startNode!.frame.origin.y - endNode!.frame.origin.y) + Node.diameter
        let size = CGSize(width: width, height: height)
        
        // set size of frame
        frame.size = size
    }
    
    /// Updates origin of the frame based on the leftmost node.
    private func updateOrigin() {
        // set location of frame around nodes
        frame.origin = CGPoint(x: min(startNode!.frame.origin.x, endNode!.frame.origin.x), y: min(startNode!.frame.origin.y, endNode!.frame.origin.y))
    }
    
    /// Determines the corner points of the start node and end node.
    private func locatePointsInFrame() {
        // predefined coordinates of nodes relative to frame
        let upperLeft = CGPoint(x: Node.radius, y: Node.radius)
        let lowerLeft = CGPoint(x: Node.radius, y: frame.size.height - Node.radius)
        let upperRight = CGPoint(x: frame.size.width - Node.radius, y: Node.radius)
        let lowerRight = CGPoint(x: frame.size.width - Node.radius, y: frame.size.height - Node.radius)
        
        // locate nodes within frame and set start and end points of line
        if startNode!.frame.origin.y > frame.origin.y {
            if startNode!.frame.origin.x <= frame.origin.x {
                startPoint = lowerLeft
                endPoint = upperRight
            } else {
                startPoint = lowerRight
                endPoint = upperLeft
            }
        } else if startNode!.frame.origin.y <= frame.origin.y {
            if startNode!.frame.origin.x <= frame.origin.x {
                startPoint = upperLeft
                endPoint = lowerRight
            } else {
                startPoint = upperRight
                endPoint = lowerLeft
            }
        }
    }
    
    /// Updates the line based on the positions of the start node and end node.
    private func updatePath() {
        path = UIBezierPath()
        
        locatePointsInFrame()
        
        let headWidth = Node.radius / 2.2
        let headLength = headWidth
        
        let length = hypot(endPoint!.x - startPoint!.x, endPoint!.y - startPoint!.y)
        let tailLength = length - Node.radius - headLength
        
        let points: [CGPoint] = [
            CGPoint(x: 0, y: 0),
            CGPoint(x: length, y: 0),
        ]
        
        let cosine = (endPoint!.x - startPoint!.x) / length
        let sine = (endPoint!.y - startPoint!.y) / length
        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: startPoint!.x, ty: startPoint!.y)
        
        let linePath = CGMutablePath()
        linePath.addLines(between: points, transform: transform)
        
        // add arrow for directed graph
        if (superview as! Graph).isDirected {
            let tipPoint = CGPoint(x: length - Node.radius, y: 0)
            
            linePath.move(to: tipPoint, transform: transform)
            linePath.addLine(to: CGPoint(x: tailLength, y: headWidth / 1.2), transform: transform)
            
            linePath.move(to: tipPoint, transform: transform)
            linePath.addLine(to: CGPoint(x: tailLength, y: -headWidth / 1.2), transform: transform)
        }
        
        linePath.closeSubpath()
        path.append(UIBezierPath(cgPath: linePath))
    }
    
    /// Draws a line from the start node to the end node.
    override func draw(_ rect: CGRect) {
        guard isVisible else { return }
        
        updatePath()
        
        // if the edge is highlighted, stroke in black
        if isHighlighted {
            highlightColor.setStroke()
        } else {
            // set color of line to stroke color of start node if graph is directed
            // otherwise, stroke color is gray
            if (superview as! Graph).isDirected {
                startNode.color.setStroke()
            } else {
                UIColor.lightGray.setStroke()
            }
        }
        
        // set thickness of the line
        path.lineWidth = lineWidth
        
        // stroke the line
        path.stroke()
        
        // draw a label containing the weight of the edge near the middle of rect
        if weight > 1 || flow != nil {
            let infoLabel = UILabel()
            
            if flow != nil {
                infoLabel.text = "\(flow!) / \(weight)"
            } else {
                infoLabel.text = String(weight)
            }
            
            infoLabel.textColor = UIColor.black
            infoLabel.font = UIFont.boldSystemFont(ofSize: 18)
            
            infoLabel.drawText(in: rect.insetBy(dx: rect.width / 2, dy: rect.height / 2))
        }
    }
    
}
