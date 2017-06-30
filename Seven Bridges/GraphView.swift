//
//  GraphView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

@IBDesignable class GraphView: UIScrollView {
    
    var isInEditMode = false
    
    var isMakingEdges = false
    
    // All nodes in the graph
    var nodes = [NodeView]()
    
    // Matrix representation of the graph TODO: implement
    var matrixForm = [[NodeView?]]()
    
    // List representation of the graph TODO: implement
    var listForm = [NodeView: NodeView?]()
    
    var selectedNodeToMakeEdge: NodeView?
    
    private var colorCycle = 0
    
    // Colors to cycle through when making new node
    private let colors = [
        // green
        UIColor(red: 0/255, green: 184/255, blue: 147/255, alpha: 1.0),
        // pink
        UIColor(red: 255/255, green: 0/255, blue: 128/255, alpha: 1.0),
        // blue
        UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0),
        // yellow
        UIColor(red: 245/255, green: 196/255, blue: 45/255, alpha: 1.0),
        // purple
        UIColor(red: 106/255, green: 24/255, blue: 170/255, alpha: 1.0)
    ]
    
    // Clears all subviews
    func clear() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // reset color cycle
        colorCycle = 0
        
        // deselect selected node
        selectedNodeToMakeEdge = nil
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isInEditMode && !isMakingEdges else { return }
        
        makeNode(with: touches)
    }
    
    // Makes a new node at the location of the touch
    private func makeNode(with touches: Set<UITouch>) {
        for touch in touches {
            // get location of the touch
            let location = touch.location(in: self)
            
            // create new node at location of touch
            let node = NodeView(color: colors[colorCycle], at: location)
            
            // add node to nodes array
            nodes.append(node)
            
            // TODO: add node to matrix representation
            
            // add node to list representation
            listForm[node] = nil
            
            // add new node to the view
            addSubview(node)
            
            // cycle through colors
            if colorCycle < colors.count - 1 {
                colorCycle += 1
            } else {
                colorCycle = 0
            }
        }
    }
    
    // Makes a new edge between the selected node and an end node
    func makeEdge(to endNode: NodeView) {
        guard selectedNodeToMakeEdge != nil else { return }
        
        let edge = EdgeView(from: selectedNodeToMakeEdge!, to: endNode)
        
        addSubview(edge)
        
        sendSubview(toBack: edge)
        
        // TODO: add new edge to data structure
        
        selectedNodeToMakeEdge = nil
    }
    
}
