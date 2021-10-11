//
//  SwingTableViewController.swift
//  Todoey
//
//  Created by majid mohmed on 8/28/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwingTableViewController: UITableViewController , SwipeTableViewCellDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
    tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
       
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! SwipeTableViewCell
        
        cell.delegate = self
        return cell
    }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("delete .....")
            self.deleteMethod(at: indexPath)
    
        }

       //customize the action appearance
  deleteAction.image = UIImage(named: "delete")

       return [deleteAction]
   
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }

    func deleteMethod(at indexpath:IndexPath)  {
        
    }
}

