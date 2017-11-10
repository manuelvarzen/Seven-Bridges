//
//  ActionsController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 9/12/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

class ActionsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var viewControllerDelegate: ViewController?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let actions = [
        "Toggle Direction",
        "Renumber Nodes",
        "Find Shortest Path (Dijkstra)",
        "Minimum Spanning Tree (Prim)",
        "Minimum Spanning Tree (Kruskal)"
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = actions[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        
        viewControllerDelegate?.didSelectAction(action, from: self)
        
        dismiss(animated: true, completion: nil)
    }
    
}
