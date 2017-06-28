//
//  ViewController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var makeButton: UIBarButtonItem!
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    
    @IBOutlet weak var graphView: GraphView!
    
    @IBAction func toggleEditMode(sender: UIBarButtonItem) {
        graphView.isInEditMode = !graphView.isInEditMode
        
        if graphView.isInEditMode {
            editButton.title = "Done"
            makeButton.isEnabled = true
            clearButton.isEnabled = true
        } else {
            editButton.title = "Edit"
            makeButton.isEnabled = false
            clearButton.isEnabled = false
        }
    }
    
    @IBAction func toggleType(sender: UIBarButtonItem) {
        graphView.isMakingEdges = !graphView.isMakingEdges
        
        if graphView.isMakingEdges {
            sender.title = "Make Nodes"
        } else {
            sender.title = "Make Edges"
        }
    }
    
    @IBAction func clearGraph(sender: UIBarButtonItem) {
        graphView.clear()
    }
}

