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
    var isDirected = false
    
    // All nodes in the graph.
    var nodes = [Node]()
    
    // TODO: Matrix representation of the graph.
    
    // List representation of the graph
    var listForm = [Node: Node?]()
    
    // Selected node to be used as the start node for a new edge.
    var selectedNodeToMakeEdge: Node?
    
    private var selectedNodes: [Node]?
    
    // Number of nodes in the graph.
    private var nodeCount = 0
    
    // Current index in the colors array.
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
    
    // Clears the graph of all nodes and edges.
    func clear() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // Delete all nodes.
        nodes.removeAll()
        
        // Delete list form.
        listForm.removeAll()
        
        // Reset color cycle.
        colorCycle = 0
        
        // Reset node count.
        nodeCount = 0
        
        // Deselect selected node.
        selectedNodeToMakeEdge = nil
        
        // Set graph to dragging mode.
        mode = .dragging
    }
    
    // Selects a start node for making a new edge.
    func makeEdge(from startNode: Node) {
        selectedNodeToMakeEdge = startNode
        
        startNode.fillColor = UIColor.white
    }
    
    // Makes a new edge between the selected node and an end node.
    func makeEdge(to endNode: Node) {
        guard selectedNodeToMakeEdge != nil else { return }
        
        // Check if start node and end node are not the same
        // If so, make an edge
        if endNode != selectedNodeToMakeEdge! {
            // Create the edge
            let edge = Edge(from: selectedNodeToMakeEdge!, to: endNode)
            
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
        
        // Clear the selected node
        selectedNodeToMakeEdge = nil
    }
    
    // Adds the given node to an array and updates the state of the node.
    func selectNode(_ node: Node) {
        // Initialize the array if nil.
        if selectedNodes == nil {
            selectedNodes = [Node]()
        }
        
        // Update state of node.
        node.fillColor = UIColor.white
        
        // Add node to array.
        selectedNodes?.append(node)
    }
    
    // Clears the selected nodes array and returns the nodes to their original state.
    func deselectNodes() {
        guard selectedNodes != nil else { return }
        
        // Return all nodes in array to original state.
        for node in selectedNodes! {
            node.fillColor = node.previousfillColor
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
        }
    }
    
    // FIXME: Recolors all nodes so that no adjacent nodes are the same color.
    func colorize() {
        nodes[0].color = UIColor.cyan
        
        for node in nodes[1...] {
            for neighbor in node.neighbors {
                if neighbor.color == node.color {
                    node.color = UIColor.red
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
            
            nodeCount += 1
            
            // Create new node at location of touch.
            let node = Node(color: colors[colorCycle], at: location)
            node.label.text = String(nodeCount)
            
            nodes.append(node)
            
            // Add node to list representation.
            listForm[node] = nil
            
            // TODO: Add node to matrix representation.
            
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
