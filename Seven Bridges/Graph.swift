//
//  GraphView.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

@IBDesignable class Graph: UIScrollView {
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            
            return nil
        }
        
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    // Mode defining the action performed by user interaction.
    enum Mode {
        case select
        case nodes
        case edges
    }
    
    // Determines what objects are being made or manipulated by user interaction.
    var mode = Mode.nodes
    
    // Determines whether the graph draws directed edges.
    var isDirected = true
    
    // All nodes in the graph.
    var nodes = [Node]()
    
    // Matrix representation of the graph.
    var matrixForm = [Node: Set<Node>]()
    
    // List representation of the graph.
    var listForm = [Node: Node?]()
    
    // Nodes that have been selected.
    var selectedNodes = [Node]()
    
    // Current index in the colors array.
    private var colorCycle = 0
    
    // Colors to cycle through when making a new node.
    private let colors = [
        // green
        UIColor(red: 100/255, green: 210/255, blue: 185/255, alpha: 1.0),
        
        // pink
        UIColor(red: 235/255, green: 120/255, blue: 180/255, alpha: 1.0),
        
        // blue
        UIColor(red: 90/255, green: 160/255, blue: 235/255, alpha: 1.0),
        
        // yellow
        UIColor(red: 245/255, green: 200/255, blue: 90/255, alpha: 1.0),
        
        // purple
        UIColor(red: 195/255, green: 155/255, blue: 245/255, alpha: 1.0)
    ]
    
    private var vc: ViewController?
    
    func assignViewController(_ vc: ViewController) {
        self.vc = vc
    }
    
    // Clears the graph of all nodes and edges.
    func clear() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // delete all nodes
        nodes.removeAll()
        
        // reset matrix form
        matrixForm.removeAll()
        
        // reset list form
        listForm.removeAll()
        
        // reset color cycle
        colorCycle = 0
        
        // deselect all selected nodes
        selectedNodes.removeAll()
    }
    
    // Selects a start node for making a new edge.
    func makeEdge(from startNode: Node) {
        selectedNodes.append(startNode)
        
        startNode.isSelected = true
    }
    
    // Makes a new edge between the selected node and an end node.
    func makeEdge(to endNode: Node) {
        guard selectedNodes.count == 1 else { return }
        
        // check if start node and end node are not the same
        // if so, make an edge
        if endNode != selectedNodes[0] && !endNode.isAdjacent(to: selectedNodes[0]) {
            // create the edge
            let edge = Edge(from: selectedNodes[0], to: endNode)
            
            // add the edge to the graph
            addSubview(edge)
            
            // aend edge to the back
            sendSubview(toBack: edge)
            
            // add new edge to matrix representation
            matrixForm[selectedNodes[0]]?.insert(endNode)
            
            // add new edge to list representation
            listForm[selectedNodes[0]] = endNode
        }
        
        // return selected node to original color config
        selectedNodes[0].isSelected = false
        
        // clear the selected node
        selectedNodes.removeAll()
    }
    
    func getEdge(between firstNode: Node, and secondNode: Node) -> Edge? {
        var selectedEdge: Edge?
        
        // get the edge
        for edge in firstNode.edges {
            if edge.endNode == secondNode || edge.startNode == secondNode {
                selectedEdge = edge
                break
            }
        }
        
        return selectedEdge
    }
    
    // Adds the given node to an array and updates the state of the node.
    func selectNode(_ node: Node) {
        if (selectedNodes.contains(node)) {
            node.isSelected = false
            
            selectedNodes.remove(at: selectedNodes.index(of: node)!)
            
            // hide properties toolbar if no nodes are selected
            if selectedNodes.count == 0 {
                vc?.propertiesToolbar.isHidden = true
            }
        } else {
            // update state of node
            node.isSelected = true
            
            // add node to array
            selectedNodes.append(node)
            
            // show properties toolbar
            vc?.propertiesToolbar.isHidden = false
            
            // update items in the toolbars based on selection
            if selectedNodes.count == 2 {
                if let selectedEdge = getEdge(between: selectedNodes.first!, and: selectedNodes.last!) {
                    vc?.edgeWeightButton.title = "Weight: \(selectedEdge.weight)"
                    vc?.edgeWeightButton.isEnabled = true
                    
                    vc?.removeEdgeButton.title = "Remove \(selectedEdge.description)"
                    vc?.removeEdgeButton.isEnabled = true
                }
            } else {
                vc?.edgeWeightButton.title = ""
                vc?.edgeWeightButton.isEnabled = false
                
                vc?.removeEdgeButton.title = ""
                vc?.removeEdgeButton.isEnabled = false
            }
        }
    }
    
    // Clears the selected nodes array and returns the nodes to their original state.
    func deselectNodes() {
        guard selectedNodes.count != 0 else { return }
        
        // return all nodes in selected nodes array to original state
        for node in selectedNodes {
            node.isSelected = false
        }
        
        // unhighlight all nodes
        for node in nodes {
            node.isHighlighted = false
        }
        
        // remove nodes from selected array
        selectedNodes.removeAll()
        
        // hide properties toolbar
        vc?.propertiesToolbar.isHidden = true
    }
    
    // Deletes all selected nodes and their edges.
    func deleteSelectedNodes() {
        guard selectedNodes.count != 0 else { return }
        
        for node in selectedNodes {
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
            
            matrixForm.removeValue(forKey: node)
            
            listForm.removeValue(forKey: node)
        }
        
        selectedNodes.removeAll()
        
        vc?.propertiesToolbar.isHidden = true
    }
    
    // Removes the selected edge.
    func removeSelectedEdge() {
        if let selectedEdge = getEdge(between: selectedNodes.first!, and: selectedNodes.last!) {
            selectedNodes.first!.edges.remove(selectedEdge)
            selectedNodes.last!.edges.remove(selectedEdge)
            
            // remove edge from matrix and list forms
            matrixForm[selectedEdge.startNode]?.remove(selectedEdge.endNode)
            
            listForm[selectedEdge.startNode]? = nil
            
            selectedEdge.removeFromSuperview()
        }
    }
    
    // Renumbers all nodes by the order that they were added to the graph.
    func renumberNodes() {
        for (index, node) in nodes.enumerated() {
            node.label.text = String(index + 1)
            node.highlight(delay: index, duration: nodes.count)
        }
    }
    
    // Returns the aggregate weight of a given path.
    func aggregateWeight(of path: [Node]) -> Int {
        var weight = 0
        
        for (index, node) in path.enumerated() {
            for edge in node.edges {
                guard index != path.count - 1 else { break }
                
                if edge.startNode == node && edge.endNode == path[index + 1] {
                    weight += edge.weight
                }
            }
        }
        
        return weight
    }
    
    private func highlightPath(_ path: [Node]) {
        for (index, node) in path.enumerated() {
            node.highlight(delay: index, duration: path.count)
        }
    }
    
    // Calculates the shortest path based on two selected nodes.
    func findShortestPath() {
        
        var traversal = [Node]()
        
        func findShortestPath(from origin: Node, to target: Node, shortestPath: [Node] = [Node]()) -> [Node]? {
            var path = shortestPath
            path.append(origin)
            
            traversal.append(origin)
            
            if target == origin {
                return path
            }
            
            var shortest: [Node]?
            var shortestAggregateWeight = 0
            
            for node in matrixForm[origin]! {
                if !path.contains(node) {
                    
                    traversal.append(node)
                    
                    if let newPath = findShortestPath(from: node, to: target, shortestPath: path) {
                        // calculate the aggregate weight of newPath
                        let aggregateWeight = self.aggregateWeight(of: newPath)
                        
                        if shortest == nil || aggregateWeight < shortestAggregateWeight {
                            shortest = newPath
                            shortestAggregateWeight = aggregateWeight
                        }
                    }
                }
            }
            
            return shortest
        }
        
        let originNode: Node
        let targetNode: Node
        
        if mode == .select && selectedNodes.count == 2 {
            originNode = selectedNodes.first!
            targetNode = selectedNodes.last!
        } else {
            originNode = nodes.first!
            targetNode = nodes.last!
        }
        
        deselectNodes()
        
        if let path = findShortestPath(from: originNode, to: targetNode) {
            highlightPath(traversal)
            highlightPath(path)
        } else {
            // create modal alert for no path found
            let message = "No path found from \(originNode) to \(targetNode)."
            
            let alert = UIAlertController(title: "Shortest Path", message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // present alert
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func editSelectedEdgeWeight() {
        guard selectedNodes.count == 2 else { return }
        
        if let editingEdge = getEdge(between: selectedNodes.first!, and: selectedNodes.last!) {
            // TODO: set weight from number chooser
            if editingEdge.weight < nodes.count {
                editingEdge.weight += 1
            } else {
                editingEdge.weight = 1
            }
            
            // update weight label
            vc?.edgeWeightButton.title = "Weight: \(editingEdge.weight)"
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // continue if graph is in nodes mode
        guard mode == .nodes else { return }
        
        // make new node where the graph view was touched
        makeNode(with: touches)
    }
    
    // Makes a new node at the location of the touch.
    private func makeNode(with touches: Set<UITouch>) {
        for touch in touches {
            // get location of the touch
            let location = touch.location(in: self)
            
            // areate new node at location of touch
            let node = Node(color: colors[colorCycle], at: location)
            node.label.text = String(nodes.count + 1)
            
            // add node to nodes array
            nodes.append(node)
            
            // add node to matrix representation
            matrixForm[node] = Set<Node>()
            
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
    
}
