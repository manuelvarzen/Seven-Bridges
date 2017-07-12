//
//  EdgeView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

@IBDesignable class EdgeView: UIView {
    
    // Thickness of the line
    private let lineWidth: CGFloat = 4
    
    // Path of the line
    private var path = UIBezierPath()
    
    // Start point of the line
    private var startPoint: CGPoint?
    
    // End point of the line
    private var endPoint: CGPoint?
    
    // Node at beginning of edge
    var startNode: NodeView?
    
    // Node at end of edge
    var endNode: NodeView?
    
    // Weight of the edge
    var weight: Double?
    
    init(from startNode: NodeView, to endNode: NodeView) {
        super.init(frame: CGRect())
        
        self.startNode = startNode
        self.endNode = endNode
        
        // Register edge with nodes.
        startNode.edges.append(self)
        endNode.edges.append(self)
        
        updateSize()
        
        updateOrigin()
        
        backgroundColor = UIColor.clear
        
        clearsContextBeforeDrawing = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Updates size, origin, and path of line relative to the start node and end node.
    func followConnectedNodes() {
        updateSize()
        updateOrigin()
        updatePath()
        setNeedsDisplay()
    }
    
    // Updates size of the frame based on the distance between the start node and end node.
    private func updateSize() {
        // Determine size of frame.
        let width = abs(startNode!.frame.origin.x - endNode!.frame.origin.x) + NodeView.diameter
        let height = abs(startNode!.frame.origin.y - endNode!.frame.origin.y) + NodeView.diameter
        let size = CGSize(width: width, height: height)
        
        // Set size of frame.
        frame.size = size
    }
    
    // Updates origin of the frame based on the leftmost node.
    private func updateOrigin() {
        // Set location of frame around nodes.
        frame.origin = CGPoint(x: min(startNode!.frame.origin.x, endNode!.frame.origin.x), y: min(startNode!.frame.origin.y, endNode!.frame.origin.y))
    }
    
    // Updates the line based on the positions of the start node and end node.
    private func updatePath() {
        path = UIBezierPath()
        
        // Predefined coordinates of nodes relative to frame.
        let upperLeft = CGPoint(x: NodeView.radius, y: NodeView.radius)
        let lowerLeft = CGPoint(x: NodeView.radius, y: frame.size.height - NodeView.radius)
        let upperRight = CGPoint(x: frame.size.width - NodeView.radius, y: NodeView.radius)
        let lowerRight = CGPoint(x: frame.size.width - NodeView.radius, y: frame.size.height - NodeView.radius)
        
        // Locate nodes within frame and set start and end points of line.
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
        
        // Define the line.
        path.move(to: startPoint!)
        path.addLine(to: endPoint!)
        
        // TODO: Add arrow for directed graph.
    }
    
    // Draws a line from the start node to the end node.
    override func draw(_ rect: CGRect) {
        updatePath()
        
        // Set color of line to stroke color of start node.
        startNode?.strokeColor.setStroke()
        
        // Set thickness of the line.
        path.lineWidth = lineWidth
        
        // Stroke the line.
        path.stroke()
    }
    
}
