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
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleDirectedEdges(_ sender: UISwitch) {
        graph.isDirected = sender.isOn
    }
}
