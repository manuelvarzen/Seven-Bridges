//
//  Graph.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//

import UIKit

@IBDesignable class Graph: UIScrollView {
    
    /// Border color of the Graph.
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
    
    /// Border width of the Graph.
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// Mode defining the action performed by user interaction.
    enum Mode {
        case select
        case viewOnly
        case nodes
        case edges
    }
    
    /// Determines the interactive behavior of the Graph.
    var mode = Mode.nodes
    
    /// Determines whether the graph draws directed or undirected edges.
    var isDirected: Bool = true {
        didSet {
            for edge in edges {
                edge.setNeedsDisplay()
            }
        }
    }
    
    /// All nodes in the graph.
    var nodes = [Node]()
    
    /// All edges in the graph.
    var edges = Set<Edge>()
    
    /// Matrix representation of the graph.
    var nodeMatrix = [Node: Set<Node>]()
    
    /// Nodes that have been selected.
    var selectedNodes = [Node]()
    
    /// Returns the selected edge when exactly two adjacent nodes are selected. Otherwise, returns nil.
    var selectedEdge: Edge? {
        guard selectedNodes.count == 2 else { return nil }
        
        return edge(from: selectedNodes.first!, to: selectedNodes.last!, directed: false)
    }
    
    /// Current index in the colors array for cycling through.
    private var colorCycle = 0
    
    /// Colors to cycle through when adding a new node to the graph.
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
    
    /// Increments the cycle of the color assigned to the next node that is created.
    private func incrementColorCycle() {
        if colorCycle < colors.count - 1 {
            colorCycle += 1
        } else {
            colorCycle = 0
        }
    }
    
    /// Clears the graph of all nodes and edges.
    func clear() {
        // remove all subviews from the graph
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        // delete all nodes
        nodes.removeAll()
        
        // delete all edges
        edges.removeAll()
        
        // reset matrix form
        nodeMatrix.removeAll()
        
        // reset color cycle
        colorCycle = 0
        
        // deselect all selected nodes
        selectedNodes.removeAll()
        
        // update the properties toolbar so that it is hidden
        updatePropertiesToolbar()
    }
    
    /// Returns an edge in the graph given a start node and an end node
    ///
    /// - parameter from: The edge's start node.
    /// - paramater to: The edge's end node.
    /// - parameter directed: Whether edge direction should be considered.
    ///
    func edge(from a: Node, to b: Node, directed: Bool = true) -> Edge? {
        if directed {
            return edges.first(where: { $0.startNode == a && $0.endNode == b })
        } else {
            var e: Edge?
            
            for edge in a.edges {
                if edge.endNode == b || edge.startNode == b {
                    e = edge
                    break
                }
            }
            
            return e
        }
    }
    
    /// Adds an edge to the graph between two given nodes.
    ///
    /// - parameter from: The edge's start node.
    /// - parameter to: The edge's end node.
    ///
    func addEdge(from a: Node, to b: Node) {
        // check to make sure a and b are not the same node and do not already have a common edge
        if a != b && !b.isAdjacent(to: a) {
            // create the edge
            let edge = Edge(from: a, to: b)
            
            // add edge to the graph
            addSubview(edge)
            
            // send edge to the back
            sendSubview(toBack: edge)
            
            // add to edge set
            edges.insert(edge)
            
            // add connection to matrix
            nodeMatrix[a]?.insert(b)
        }
        
        // deselect nodes
        a.isSelected = false
        b.isSelected = false
        
        // clear selected nodes
        selectedNodes.removeAll()
    }
    
    /// Adds a new node to the graph at the location of the touch(es) given.
    ///
    /// - paramater with: The set of touches used to determine the location of the node.
    ///
    private func addNode(with touches: Set<UITouch>) {
        for touch in touches {
            // get location of the touch
            let location = touch.location(in: self)
            
            // create new node at location of touch
            let node = Node(color: colors[colorCycle], at: location)
            node.label.text = String(nodes.count + 1)
            
            // add node to nodes array
            nodes.append(node)
            
            // add node to matrix representation
            nodeMatrix[node] = Set<Node>()
            
            // add new node to the view
            addSubview(node)
            
            incrementColorCycle()
        }
    }
    
    /// Adds the given node to the selectedNodes array and updates the state of the node.
    ///
    /// - parameter node: The node to be selected.
    ///
    func select(_ node: Node) {
        if (selectedNodes.contains(node)) {
            // update state of node
            node.isSelected = false
            
            // remove node from the array
            selectedNodes.remove(at: selectedNodes.index(of: node)!)
        } else {
            // update state of node
            node.isSelected = true
            
            // add node to array
            selectedNodes.append(node)
        }
        
        if mode != .edges {
            updatePropertiesToolbar()
        }
    }
    
    /// Updates the appearance of the properties toolbar based on which nodes are selected.
    private func updatePropertiesToolbar() {
        // hide the toolbar if no nodes are selected
        if selectedNodes.isEmpty {
            vc?.propertiesToolbar.isHidden = true
            return
        }
        
        vc?.propertiesToolbar.isHidden = false
        
        // detect a selected edge between two nodes
        if let edge = selectedEdge {
            vc?.edgeWeightIndicator.title = String(edge.weight)
            
            vc?.edgeWeightMinusButton.title = "-"
            vc?.edgeWeightMinusButton.isEnabled = true
            
            vc?.edgeWeightPlusButton.title = "+"
            vc?.edgeWeightPlusButton.isEnabled = true
            
            vc?.removeEdgeButton.title = "Remove \(edge.description)"
            vc?.removeEdgeButton.isEnabled = true
        } else {
            vc?.edgeWeightIndicator.title = ""
            vc?.edgeWeightIndicator.isEnabled = false
            
            vc?.edgeWeightMinusButton.title = ""
            vc?.edgeWeightMinusButton.isEnabled = false
            
            vc?.edgeWeightPlusButton.title = ""
            vc?.edgeWeightPlusButton.isEnabled = false
            
            vc?.removeEdgeButton.title = ""
            vc?.removeEdgeButton.isEnabled = false
        }
    }
    
    /// Clears the selected nodes array and returns the nodes to their original state.
    ///
    /// - parameter unhighlight: If unhighlight is true, all nodes and edges will be unhighlighted.
    /// - parameter resetEdgeProperties: If true, edge flow will be reset to nil.
    ///
    func deselectNodes(unhighlight: Bool = false, resetEdgeProperties: Bool = false) {
        // return all nodes in selected nodes array to original state
        for node in selectedNodes {
            node.isSelected = false
        }
        
        if resetEdgeProperties {
            for edge in edges {
                edge.flow = nil
            }
        }
        
        // unhighlight all nodes and edges
        if unhighlight {
            for node in nodes {
                node.highlighted(false)
            }
            
            for edge in edges {
                edge.highlighted(false)
            }
        }
        
        // remove nodes from selected array
        selectedNodes.removeAll()
        
        updatePropertiesToolbar()
    }
    
    /// Deletes a given node and its edges.
    ///
    /// - parameter node: The node to be deleted.
    ///
    func delete(_ node: Node) {
        node.removeFromSuperview()
        
        for edge in node.edges {
            edge.removeFromSuperview()
            
            // remove edge from its start node
            if let index = edge.startNode?.edges.index(of: edge) {
                edge.startNode?.edges.remove(at: index)
            }
            
            // remove edge from its end node
            if let index = edge.endNode?.edges.index(of: edge) {
                edge.endNode?.edges.remove(at: index)
            }
        }
        
        nodes.remove(at: nodes.index(of: node)!)
        
        nodeMatrix.removeValue(forKey: node)
    }
    
    /// Deletes all selected nodes and their edges.
    func deleteSelectedNodes() {
        guard !selectedNodes.isEmpty else { return }
        
        for node in selectedNodes {
            delete(node)
        }
        
        selectedNodes.removeAll()
        
        updatePropertiesToolbar()
    }
    
    /// Removes the selected edge from the Graph.
    func removeSelectedEdge() {
        if let edge = selectedEdge {
            selectedNodes.first!.edges.remove(edge)
            selectedNodes.last!.edges.remove(edge)
            
            edges.remove(edge)
            
            // remove edge from matrix and list forms
            nodeMatrix[edge.startNode]?.remove(edge.endNode)
            
            edge.removeFromSuperview()
            
            updatePropertiesToolbar()
        }
    }
    
    /// Removes all edges from the graph.
    func removeAllEdges() {
        for node in nodes {
            node.edges.removeAll()
            nodeMatrix[node]?.removeAll()
        }
        
        for edge in edges {
            edge.removeFromSuperview()
        }
        
        edges.removeAll()
    }
    
    /// Changes all edge weights to the given weight or resets them all to the default value of 1.
    ///
    /// - parameter to: The weight that will be applied to all edges.
    ///
    func resetAllEdgeWeights(to weight: Int = 1) {
        for edge in edges {
            edge.weight = weight
        }
    }
    
    /// Renumbers all nodes by the order that they were added to the graph.
    func renumberNodes() {
        guard !nodes.isEmpty else {
            Announcement.new(title: "Renumber Nodes", message: "There are no nodes to renumber.")
            return
        }
        
        for (index, node) in nodes.enumerated() {
            node.label.text = String(index + 1)
        }
    }
    
    /// Finds and identifies the shortest path between two selected nodes.
    func shortestPath() {
        guard mode == .select && selectedNodes.count == 2 else {
            Announcement.new(title: "Shortest Path", message: "Please select an origin node and a target node before using the Shortest Path algorithm.")
            return
        }
        
        mode = .viewOnly // do not allow the graph to be altered during execution
        
        func resumeFunction() {
            var traversals = [Path]()
            
            func findShortestPath(from origin: Node, to target: Node, shortestPath: Path = Path()) -> Path? {
                let path = Path(shortestPath)
                path.append(origin)
                
                if target == origin {
                    return path
                }
                
                // the shortest path that will be returned
                var shortest: Path?
                
                // equals 0 when shortest is nil
                var shortestAggregateWeight = 0
                
                for node in origin.adjacentNodes(directed: isDirected) {
                    if !path.contains(node) {
                        if let newPath = findShortestPath(from: node, to: target, shortestPath: path) {
                            
                            // add the new path to the history of traversals
                            traversals.append(newPath)
                            
                            // calculate the aggregate weight of newPath
                            let aggregateWeight = newPath.weight
                            
                            if shortest == nil || aggregateWeight < shortestAggregateWeight {
                                shortest = newPath
                                shortestAggregateWeight = aggregateWeight
                            }
                        }
                    }
                }
                
                return shortest
            }
            
            let originNode = selectedNodes.first!
            let targetNode = selectedNodes.last!
            
            deselectNodes()
            
            if let path = findShortestPath(from: originNode, to: targetNode) {
                // remove the shortest path from the traversal history
                traversals.removeLast()
                
                // outline the traversals
                for (i, path) in traversals.enumerated() {
                    path.outline(duration: 2, wait: i * 3, color: UIColor.lightGray)
                }
                
                // outline the shortest path
                path.outline(wait: traversals.count * 3)
            } else {
                // create modal alert for no path found
                Announcement.new(title: "Shortest Path", message: "No path found from \(originNode) to \(targetNode).")
            }
        }
        
        if !isDirected {
            // notify user that edges must be directed in order for the algorithm to run
            Announcement.new(title: "Shortest Path", message: "Edges will be made directed in order for the algorithm to run.", action: { (action: UIAlertAction!) -> Void in
                self.isDirected = true
                resumeFunction()
            })
        } else {
            resumeFunction()
        }
    }
    
    /// Reduces the graph to find a minimum spanning tree using Prim's Algorithm.
    func primMinimumSpanningTree() {
        guard mode == .select && selectedNodes.count == 1 else {
            Announcement.new(title: "Minimum Spanning Tree", message: "Please select a root node before running Prim's Minimum Spanning Tree algorithm.")
            return
        }
        
        mode = .viewOnly // make graph view-only
        
        func resumeFunction() {
            var pool = Set<Node>(nodes) // all nodes
            var distance = [Node: Int]() // distance from a node to the root
            var parent = [Node: Node?]()
            var children = [Node: [Node]]()
            
            // finds the node with the minimum distance from a dictionary
            func getMin(from d: [Node: Int]) -> Node {
                var shortest: Node?
                
                for (node, distance) in d {
                    if shortest == nil || distance < d[shortest!]! {
                        shortest = node
                    }
                }
                
                return shortest!
            }
            
            // "initialize" all nodes
            for node in pool {
                distance[node] = Int.max // distance is "infinity"
                parent[node] = nil
                children[node] = [Node]()
            }
            
            var root = selectedNodes.first!
            distance[root] = 0 // distance from root to itself is 0
            
            while !pool.isEmpty {
                let currentNode = getMin(from: distance)
                distance.removeValue(forKey: currentNode)
                pool.remove(currentNode)
                
                for nextNode in currentNode.adjacentNodes(directed: false) {
                    if let edge = currentNode.getEdge(to: nextNode) {
                        let newDistance = edge.weight
                        
                        if pool.contains(nextNode) && newDistance < distance[nextNode]! {
                            parent[nextNode] = currentNode
                            children[currentNode]!.append(nextNode)
                            distance[nextNode] = newDistance
                        }
                    }
                }
            }
            
            deselectNodes()
            
            // tree as path of edges
            var path = Path()
            
            // recurses through the children dictionary to build a path of edges
            func buildPath(from parent: Node) {
                for child in children[parent]! {
                    if let edge = parent.getEdge(to: child) {
                        path.append(edge)
                        buildPath(from: child)
                    }
                }
            }
            
            buildPath(from: root)
            
            path.outline(wait: 0)
        }
        
        if isDirected {
            // notify user that edges must be undirected in order for the algorithm to run
            Announcement.new(title: "Minimum Spanning Tree", message: "Edges will be made undirected in order for the algorithm to run.", action: { (action: UIAlertAction!) -> Void in
                self.isDirected = false
                resumeFunction()
            })
        } else {
            resumeFunction()
        }
    }
    
    /// Kruskal's Algorithm
    func kruskalMinimumSpanningTree() {
        // enter select mode in order to properly clear highlighted edges when algorithm completes
        vc?.enterSelectMode((vc?.selectModeButton)!)
        
        mode = .viewOnly
        
        func resumeFunction() {
            var s = [Edge](edges) // all edges in the graph
            var f = Set<Set<Node>>() // forest of trees
            
            let e = Path() // edges in the final tree
            
            // sort edges by weight
            s = s.sorted(by: {
                $0.weight < $1.weight
            })
            
            // create tree in forest for each node
            for node in nodes {
                var tree = Set<Node>()
                tree.insert(node)
                
                f.insert(tree)
            }
            
            // loop through edges
            for edge in s {
                // tree containing start node of edge
                let u = f.first(where: { set in
                    set.contains(edge.startNode!)
                })
                
                // tree containing end node of edge
                let y = f.first(where: { set in
                    set.contains(edge.endNode!)
                })
                
                if u != y {
                    // union u and y, add to f, and delete u and y
                    let uy = u?.union(y!)
                    f.remove(u!)
                    f.remove(y!)
                    f.insert(uy!)
                    
                    e.append(edge)
                }
            }
            
            deselectNodes()
            
            e.outline(wait: 0)
        }
        
        if isDirected {
            // notify user that edges must be undirected in order for the algorithm to run
            Announcement.new(title: "Minimum Spanning Tree", message: "Edges will be made undirected in order for the algorithm to run.", action: { (action: UIAlertAction!) -> Void in
                self.isDirected = false
                resumeFunction()
            })
        } else {
            resumeFunction()
        }
    }
    
    /// Ford-Fulkerson Algorithm
    func fordFulkersonMaxFlow() {
        guard mode == .select && selectedNodes.count == 2 else {
            Announcement.new(title: "Ford-Fulkerson", message: "Please select two nodes for calculating max flow before running the Ford-Fulkerson algorithm.")
            return
        }
        
        mode = .viewOnly
        
        // initialize all edges to flow of zero
        for edge in edges {
            edge.flow = 0
        }
        
        var backwardEdges = Set<Edge>()
        
        // returns an augmenting path from origin to target
        func augmentedPath(from origin: Node, to target: Node, path: Path = Path()) -> Path? {
            if origin == target {
                return path
            }

            // iterate over all edges connected to the origin
            for edge in origin.edges {
                if !path.edges.contains(edge) {
                    let newPath = Path(path)
                    
                    // edge forward
                    if edge.residualCapacity! > 0 && origin == edge.startNode {
                        newPath.append(edge)
                        
                        if let result = augmentedPath(from: edge.endNode!, to: target, path: newPath) {
                            return result
                        }
                    }
                    
                    // edge backward
                    if edge.flow! > 0 && edge.residualCapacity! > 0 && origin == edge.endNode {
                        newPath.append(edge, ignoreNodes: true)
                        backwardEdges.insert(edge)
                        
                        if let result = augmentedPath(from: edge.startNode!, to: target, path: newPath) {
                            return result
                        }
                    }
                }
            }

            return nil
        }
        
        // while there is a path from s to t where all edges have capacity > 0...
        while let path = augmentedPath(from: selectedNodes.first!, to: selectedNodes.last!) {
            // move flow along edges in path
            if let flow = path.residualCapacity {
                for edge in path.edges {
                    if backwardEdges.contains(edge) {
                        edge.flow! -= flow
                    } else {
                        edge.flow! += flow
                    }
                }
                
                backwardEdges.removeAll()
            }
        }
        
        // assert that the outbound flow of every node (except s and t) is equal to its inbound flow
        for (i, node) in nodes.enumerated() {
            if i != 0 && i != nodes.count - 1 {
                let outbound = node.outboundFlow
                let inbound = node.inboundFlow
                assert(outbound == inbound, "\(node)'s inbound flow was \(inbound) but its outbound flow was \(outbound).")
            }
        }

        // announce the max flow
        Announcement.new(title: "Ford-Fulkerson Max Flow", message: "The max flow is \(selectedNodes.last!.inboundFlow).")
        
        deselectNodes()
    }
    
    /// Bron-Kerbosch community detection algorithm
    func bronKerbosch() {
        mode = .viewOnly
        
        func recurse(r: inout Set<Node>, p: inout Set<Node>, x: inout Set<Node>) {
            if p.isEmpty && x.isEmpty {
                // r should now be a community
                return
            }
            
            // mutable copy of p
            var pCopy = Set<Node>(p)
            
            for node in p {
                r.insert(node)
                var pt = pCopy.intersection(node.adjacentNodes(directed: isDirected))
                var xt = x.intersection(node.adjacentNodes(directed: isDirected))
                
                recurse(r: &r, p: &pt, x: &xt)
                
                r.remove(node)
                pCopy.remove(node)
                x.insert(node)
            }
        }
        
        var r = Set<Node>()
        var p = Set<Node>(nodes)
        var x = Set<Node>()
        
        recurse(r: &r, p: &p, x: &x)
        
        if r.isEmpty {
            Announcement.new(title: "Bron-Kerbosch", message: "No community could be found in the graph.")
        } else {
            for node in r {
                node.highlighted()
            }
        }
    }
    
    /// Prepares a pre-designed flow network.
    func prepareGraph() {
        clear()
        
        for i in 1...4 {
            var x = center.x
            var y = center.y
            
            switch i {
            case 1:
                x -= 250
            case 2:
                y -= 200
            case 3:
                y += 200
            case 4:
                x += 250
            default:
                continue
            }
            
            let point = CGPoint(x: x, y: y)
            let node = Node(color: colors[colorCycle], at: point)
            
            node.label.text = String(i)
            
            nodeMatrix[node] = Set<Node>()
            nodes.append(node)
            addSubview(node)
            
            incrementColorCycle()
        }
        
        // create edge from 1 to 2
        addEdge(from: nodes[0], to: nodes[1])
        edge(from: nodes[0], to: nodes[1])?.weight = 5
        
        // edge from 1 to 3
        addEdge(from: nodes[0], to: nodes[2])
        edge(from: nodes[0], to: nodes[2])?.weight = 5
        
        // edge from 2 to 3
        addEdge(from: nodes[1], to: nodes[2])
        edge(from: nodes[1], to: nodes[2])?.weight = 3
        
        // edge from 2 to 4
        addEdge(from: nodes[1], to: nodes[3])
        edge(from: nodes[1], to: nodes[3])?.weight = 3
        
        // edge from 3 to 4
        addEdge(from: nodes[2], to: nodes[3])
        edge(from: nodes[2], to: nodes[3])?.weight = 7
    }
    
    /// Shifts a selected edge's weight by a given integer value.
    ///
    /// - parameter by: The value by which to shift the edge's weight.
    ///
    func shiftSelectedEdgeWeight(by shift: Int) {
        if let edge = selectedEdge {
            edge.weight += shift
            
            // update weight label
            vc?.edgeWeightIndicator.title = String(edge.weight)
        }
    }
    
    /// Called when all touches on the screen have ended.
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // continue if graph is in nodes mode
        guard mode == .nodes else { return }
        
        // make new node where the graph view was touched
        addNode(with: touches)
    }
    
}
