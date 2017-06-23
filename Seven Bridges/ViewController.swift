//
//  ViewController.swift
//  Seven Bridges
//
//  Created by Dillon Fagan on 6/23/17.
//  Copyright © 2017 Dillon Fagan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // TEMP
    @IBOutlet var blueNode: NodeView!
    @IBOutlet var pinkNode: NodeView!
    @IBOutlet var greenNode: NodeView!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var graphView: GraphView!
    
    @IBAction func toggleEditMode(sender: UIBarButtonItem) {
        graphView.isInEditMode = !graphView.isInEditMode
        
        if graphView.isInEditMode {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }
    
}

