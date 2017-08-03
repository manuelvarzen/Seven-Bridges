//
//  GraphView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

@IBDesignable class Graph: UIScrollView {
    
    // Mode defining the action performed by user interaction.
    enum Mode {
        case dragging
        case selecting
        case nodes
        case edges
    }
    
    // Determines what objects are being made or manipulated by user interaction.
    var mode = Mode.dragging
    
    // Determines whether the graph draws directed edges.
    var isDirected = true
    
    // All nodes in the graph.
    // TODO: Change to set instead of array for easier removal by reference.
    var nodes = [Node]()
    
    // Matrix representation of the graph.
    var matrixForm = [Node: [Node?]]()
    
    // List representation of the graph
    var listForm = [Node: Node?]()
    
    // Selected node to be used as the start node for a new edge.
    var selectedNodeToMakeEdge: Node?
    
    // Nodes that have been selected.
    private var selectedNodes: [Node]?
    
    // Current index in the colors array.
    private var colorCycle = 0
    
    // Colors to cycle through when making a new node.
    private let colors = [
        // Green
        UIColor(red: 100/255, green: 210/255, blue: 185/255, alpha: 1.0),
        // Pink
        UIColor(red: 235/255, green: 120/255, blue: 180/255, alpha: 1.0),
        // Blue
        UIColor(red: 90/255, green: 160/255, blue: 235/255, alpha: 1.0),
        // Yellow
        UIColor(red: 245/255, green: 200/255, blue: 90/255, alpha: 1.0),
        // Purple
        UIColor(red: 195/255, green: 155/255, blue: 245/255, alpha: 1.0)
    ]
    
    // Clears the graph of all nodes and edges.
    func clear() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // Delete all nodes.
        nodes.removeAll()
        
        // Reset matrix form.
        matrixForm.removeAll()
        
        // Reset list form.
        listForm.removeAll()
        
        // Reset color cycle.
        colorCycle = 0
        
        // Deselect selected node.
        selectedNodeToMakeEdge = nil
        
        // Set graph to dragging mode.
        mode = .dragging
    }
    
    // Selects a start node for making a new edge.
    func makeEdge(from startNode: Node) {
        selectedNodeToMakeEdge = startNode
        
        startNode.isSelected = true
    }
    
    // Makes a new edge between the selected node and an end node.
    func makeEdge(to endNode: Node) {
        guard selectedNodeToMakeEdge != nil else { return }
        
        // Check if start node and end node are not the same.
        // If so, make an edge.
        if endNode != selectedNodeToMakeEdge! {
            // Create the edge.
            let edge = Edge(from: selectedNodeToMakeEdge!, to: endNode)
            
            // Add the edge to the graph.
            addSubview(edge)
            
            // Send edge to the back.
            sendSubview(toBack: edge)
            
            // Add new edge to matrix representation
            matrixForm[selectedNodeToMakeEdge!]?.append(endNode)
            
            // Add new edge to list representation.
            listForm[selectedNodeToMakeEdge!] = endNode
        }
        
        // Return selected node to original color config.
        selectedNodeToMakeEdge!.isSelected = false
        
        // Clear the selected node.
        selectedNodeToMakeEdge = nil
    }
    
    // Adds the given node to an array and updates the state of the node.
    func selectNode(_ node: Node) {
        // Initialize the array if nil.
        if selectedNodes == nil {
            selectedNodes = [Node]()
        }
        
        if (selectedNodes?.contains(node))! {
            node.isSelected = false
            
            if let index = selectedNodes?.index(of: node) {
                selectedNodes?.remove(at: index)
            }
        } else {
            // Update state of node.
            node.isSelected = true
            
            // Add node to array.
            selectedNodes?.append(node)
        }
    }
    
    // Clears the selected nodes array and returns the nodes to their original state.
    func deselectNodes() {
        guard selectedNodes != nil else { return }
        
        // Return all nodes in array to original state.
        for node in selectedNodes! {
            node.isSelected = false
        }
        
        // Set the array to nil.
        selectedNodes = nil
    }
    
    // Deletes all selected nodes and their edges.
    func deleteSelectedNodes() {
        guard selectedNodes != nil else { return }
        
        for node in selectedNodes! {
            node.removeFromSuperview()
            
            for edge in node.edges {
                edge.removeFromSuperview()
                
                if let index = edge.startNode?.edges.index(of: edge) {
                    edge.startNode?.edges.remove(at: index)
                }
                
                if let index = edge.endNode?.edges.index(of: edge) {
                    edge.endNode?.edges.remove(at: index)
                }
            }
            
            nodes.remove(at: nodes.index(of: node)!)
        }
    }
    
    // Renumbers all nodes by the order that they were added to the graph.
    func renumberNodes() {
        for (index, node) in nodes.enumerated() {
            node.label.text = String(index + 1)
            node.setNeedsDisplay()
        }
    }
    
    func shortestPath() {
        var path: [Node]?
        
        if selectedNodes?.count == 2 {
            path = selectedNodes![0].shortestPath(to: selectedNodes![1])
            
            if (path?.isEmpty)! {
                print("No path found.")
                // Modal dialogue
            } else {
                for (index, node) in path!.enumerated() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(index), execute: {
                        node.isHighlighted = true
                    })
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(path!.count), execute: {
                        node.isHighlighted = false
                    })
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Continue if graph is in nodes mode.
        guard mode == .nodes else { return }
        
        // Make new node where the graph view was touched.
        makeNode(with: touches)
    }
    
    // Makes a new node at the location of the touch.
    private func makeNode(with touches: Set<UITouch>) {
        for touch in touches {
            // Get location of the touch.
            let location = touch.location(in: self)
            
            // Create new node at location of touch.
            let node = Node(color: colors[colorCycle], at: location)
            node.label.text = String(nodes.count + 1)
            
            // Add node to nodes array.
            nodes.append(node)
            
            // Add node to matrix representation.
            matrixForm[node] = []
            
            // Add node to list representation.
            listForm[node] = nil
            
            // Add new node to the view.
            addSubview(node)
            
            // Cycle through colors.
            if colorCycle < colors.count - 1 {
                colorCycle += 1
            } else {
                colorCycle = 0
            }
        }
    }
    
}
