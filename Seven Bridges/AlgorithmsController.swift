//
//  AlgorithmsController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 9/12/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

class AlgorithmsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var viewControllerDelegate: ViewController?
    
    @IBOutlet weak var tableView: UITableView!
    
    private let algorithms = [
        "Renumber Nodes",
        "Find Shortest Path (Dijkstra)",
        "Minimum Spanning Tree (Prim)"
    ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return algorithms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = algorithms[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let algorithm = algorithms[indexPath.row]
        
        viewControllerDelegate?.didSelectAlgorithm(algorithm, from: self)
        
        dismiss(animated: true, completion: nil)
    }
    
}
