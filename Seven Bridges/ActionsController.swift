//
//  ActionsController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 9/12/17.
//

import UIKit

class ActionsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /// The parent view controller that contains the graph.
    weak var viewControllerDelegate: ViewController?
    
    /// The graph that the actions will be applied to.
    weak var graph: Graph?
    
    /// The table view containing the data.
    @IBOutlet weak var tableView: UITableView!
    
    /// Labels for the actions in the table.
    private let actions = [
        "Toggle Direction",
        "Renumber Nodes",
        "Reset Edge Weights",
        "Remove All Edges",
        "Shortest Path (Dijkstra)",
        "Minimum Spanning Tree (Prim)",
        "Minimum Spanning Tree (Kruskal)",
        "Max Flow (Ford-Fulkerson)",
        "Maximal Clique (Bron-Kerbosch)",
        "Load Flow Network Example"
    ]
    
    /// Performs additional setup when the view is ready to be shown.
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize.height = CGFloat(actions.count * 44)
    }
    
    /// Returns the number of rows needed in the table to display the data.
    ///
    /// - parameter tableView: The table view that will hold the rows.
    /// - parameter numberofRowsInSection: The section of the table.
    ///
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    /// Returns a cell in the table view given the table view and the row index.
    ///
    /// - parameter tableView: The table view that holds the rows.
    /// - parameter cellForRowAt: The index of the row in the table.
    ///
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = actions[indexPath.row]
        
        return cell
    }
    
    /// Called when a cell in the table was selected.
    ///
    /// - parameter tableView: The table view that holds the cell.
    /// - parameter didSelectRowAt: Index of the row.
    ///
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectAction(indexPath.row)
    }
    
    /// Dismisses the view and calls the matching algorithm from the graph.
    ///
    /// - parameter i: Index of the row selected in the graph.
    ///
    private func didSelectAction(_ i: Int) {
        dismiss(animated: true, completion: nil)
        
        switch i {
        case 0:
            graph?.isDirected = !(graph?.isDirected)!
        case 1:
            graph?.renumberNodes()
        case 2:
            graph?.resetAllEdgeWeights()
        case 3:
            graph?.removeAllEdges()
        case 4:
            graph?.shortestPath()
        case 5:
            graph?.primMinimumSpanningTree()
        case 6:
            graph?.kruskalMinimumSpanningTree()
        case 7:
            graph?.fordFulkersonMaxFlow()
        case 8:
            graph?.bronKerbosch()
        case 9:
            graph?.prepareFlowNetworkExample()
        default:
            print("An unknown action was selected from the Actions Menu.")
        }
    }
}
