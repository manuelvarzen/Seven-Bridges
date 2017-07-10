//
//  GraphView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

@IBDesignable class GraphView: UIScrollView {
    
    // Mode defining the action performed by user interaction
    enum Mode {
        case dragging
        case selecting
        case nodes
        case edges
    }
    
    // Determines what objects are being made or manipulated by user interaction
    var mode = Mode.dragging
    
    // Whether the graph is directed
    var isDirected = false
    
    // Matrix representation of the graph
    var matrixForm = [[NodeView?]]()
    
    // List representation of the graph
    var listForm = [NodeView: NodeView?]()
    
    // Selected node to be used as the start node for a new edge
    var selectedNodeToMakeEdge: NodeView?
    
    // Current index in the colors array
    private var colorCycle = 0
    
    // Colors to cycle through when making a new node.
    private let colors = [
        // Green
        UIColor(red: 0/255, green: 184/255, blue: 147/255, alpha: 1.0),
        // Pink
        UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1.0),
        // Blue
        UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0),
        // Yellow
        UIColor(red: 245/255, green: 196/255, blue: 45/255, alpha: 1.0),
        // Purple
        UIColor(red: 106/255, green: 24/255, blue: 170/255, alpha: 1.0)
    ]
    
    // Clears all subviews.
    func clear() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // Reset color cycle
        colorCycle = 0
        
        // Deselect selected node
        selectedNodeToMakeEdge = nil
    }
    
    // Selects a start node for making a new edge.
    func makeEdge(from startNode: NodeView) {
        selectedNodeToMakeEdge = startNode
        
        startNode.previousfillColor = startNode.fillColor
        startNode.fillColor = UIColor.white
        startNode.setNeedsDisplay()
    }
    
    // Makes a new edge between the selected node and an end node.
    func makeEdge(to endNode: NodeView) {
        guard selectedNodeToMakeEdge != nil else { return }
        
        // Check if start node and end node are not the same
        // If so, make an edge
        if endNode != selectedNodeToMakeEdge! {
            // Create the edge
            let edge = EdgeView(from: selectedNodeToMakeEdge!, to: endNode)
            
            // Add the edge to the graph
            addSubview(edge)
            
            // Send edge to the back
            sendSubview(toBack: edge)
            
            // TODO: Add new edge to matrix representation
            
            // Add new edge to list representation
            listForm[selectedNodeToMakeEdge!] = endNode
        }
        
        // Return selected node to original color config
        selectedNodeToMakeEdge!.fillColor = selectedNodeToMakeEdge!.previousfillColor
        selectedNodeToMakeEdge!.setNeedsDisplay()
        
        // Clear the selected node
        selectedNodeToMakeEdge = nil
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard mode == .nodes else { return }
        
        makeNode(with: touches)
    }
    
    // Makes a new node at the location of the touch.
    private func makeNode(with touches: Set<UITouch>) {
        for touch in touches {
            // Get location of the touch
            let location = touch.location(in: self)
            
            // Create new node at location of touch
            let node = NodeView(color: colors[colorCycle], at: location)
            
            // TODO: Add node to matrix representation
            
            // Add node to list representation
            listForm[node] = nil
            
            // Add new node to the view
            addSubview(node)
            //addSubview(node.label)
            
            // Cycle through colors
            if colorCycle < colors.count - 1 {
                colorCycle += 1
            } else {
                colorCycle = 0
            }
        }
    }
    
}
