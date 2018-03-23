//
//  ActionsController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 9/12/17.
//

import UIKit

class ActionsController: UITableViewController {
    
    /// The parent view controller that contains the graph.
    weak var viewControllerDelegate: ViewController!
    
    /// The graph that the actions will be applied to.
    weak var graph: Graph!
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismissView()
    }
    
    @IBAction func toggleDirectedEdges(_ sender: UISwitch) {
        graph.isDirected = sender.isOn
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissView()
        
        switch indexPath.section {
        case 1:
            quickAction(at: indexPath.row)
        case 2:
            algorithm(at: indexPath.row)
        case 3:
            template(at: indexPath.row)
        default:
            print("A cell was selected in section: \(indexPath.section)")
        }
    }
    
    private func quickAction(at row: Int) {
        switch row {
        case 0:
            graph.renumberNodes()
        case 1:
            graph.resetAllEdgeWeights()
        case 2:
            graph.removeAllEdges()
        default:
            print("A cell was selected in row: \(row)")
        }
    }
    
    private func algorithm(at row: Int) {
        switch row {
        case 0:
            graph.shortestPath()
        case 1:
            graph.primMinimumSpanningTree()
        case 2:
            graph.kruskalMinimumSpanningTree()
        case 3:
            graph.fordFulkersonMaxFlow()
        case 4:
            graph.bronKerbosch()
        default:
            print("A cell was selected in row: \(row)")
        }
    }
    
    private func template(at row: Int) {
        switch row {
        case 0:
            graph.prepareFlowNetworkExample()
        default:
            print("A cell was selected in row: \(row)")
        }
    }
    
    private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
}
