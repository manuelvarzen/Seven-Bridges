//
//  ActionsController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 9/12/17.
//

import UIKit

class ActionsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var viewControllerDelegate: ViewController?
    
    weak var graph: Graph?
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize.height = CGFloat(actions.count * 44)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = actions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectAction(indexPath.row)
    }
    
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
            print("An unknown action was selected from the ActionsMenu.")
        }
    }
}
