//
//  EdgeView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

@IBDesignable class EdgeView: UIView {
    
    // Thickness of the line
    private let lineWidth = CGFloat(4)
    
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
    
    init(from startNode: NodeView, to endNode: NodeView) {
        super.init(frame: CGRect())
        
        self.startNode = startNode
        self.endNode = endNode
        
        // register edge with nodes
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
    
    func updateSize() {
        // determine size of frame
        let width = abs(startNode!.frame.origin.x - endNode!.frame.origin.x) + NodeView.diameter
        let height = abs(startNode!.frame.origin.y - endNode!.frame.origin.y) + NodeView.diameter
        let size = CGSize(width: width, height: height)
        
        // set size of frame
        frame.size = size
    }
    
    func updateOrigin() {
        // set location of frame around nodes
        frame.origin = CGPoint(x: min(startNode!.frame.origin.x, endNode!.frame.origin.x), y: min(startNode!.frame.origin.y, endNode!.frame.origin.y))
    }
    
    func updatePath() {
        path = UIBezierPath()
        
        // predefined coordinates of nodes relative to frame
        let upperLeft = CGPoint(x: NodeView.radius, y: NodeView.radius)
        let lowerLeft = CGPoint(x: NodeView.radius, y: frame.size.height - NodeView.radius)
        let upperRight = CGPoint(x: frame.size.width - NodeView.radius, y: NodeView.radius)
        let lowerRight = CGPoint(x: frame.size.width - NodeView.radius, y: frame.size.height - NodeView.radius)
        
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
        
        // define the line
        path.move(to: startPoint!)
        path.addLine(to: endPoint!)
    }
    
    // Draws a line from startNode to endNode
    override func draw(_ rect: CGRect) {
        updatePath()
        
        // set color of line to stroke color of start node
        startNode?.strokeColor.setStroke()
        
        // set thickness of the line
        path.lineWidth = lineWidth
        
        // stroke the line
        path.stroke()
    }
    
}
