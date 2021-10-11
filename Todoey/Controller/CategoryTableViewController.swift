//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by majid mohmed on 8/8/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class CategoryTableViewController: SwingTableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var arrCategoryList = [CategoryItem]()
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          
          loadData()
      
    }

    // MARK: - Table view data source
    
    

  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       
        
      
         return arrCategoryList.count
    
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
       let cell =  super.tableView(tableView, cellForRowAt: indexPath)
          
        
        cell.textLabel?.text = arrCategoryList[indexPath.row].name
        cell.backgroundColor = UIColor(hexString: arrCategoryList[indexPath.row].colour ?? "5856D6") 
        return cell
    }

    //MARK: - tableView didselected Method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Go TO Items", sender: self)
        
        
       
     
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
             let destination = segue.destination as! ListViewController
                
               
        if let indexpath = tableView.indexPathForSelectedRow {
                destination.selectedCategory = arrCategoryList[indexpath.row]
        }
        
          
            
               
        
 
    }
    
    
    //MARK: - Adding Item in Category
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            print("succedded")
            
            let newItem = CategoryItem(context: self.context)
            newItem.name = textField.text!
            newItem.colour = UIColor.randomFlat().hexValue()
            self.arrCategoryList.append(newItem)
            self.saveData()
         
            
            
        }
        
        alert.addTextField { (categoryTextField) in
            categoryTextField.placeholder = "Add New Category Please!"
            textField = categoryTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Saving data
    func saveData()  {
        do {
             try context.save()
        }catch {
            print("Error from Saving data \(error)")
        }
       
        tableView.reloadData()
    }
    
    //MARK: - Loading or Read Data
    func loadData()  {
        let request:NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest()
        do {
            arrCategoryList = try context.fetch(request)
        }catch{
            print("Error from loading Data \(error)")
        }
        tableView.reloadData()
            
    }
    override func deleteMethod(at indexpath: IndexPath) {
        
        context.delete(arrCategoryList[indexpath.row])
        arrCategoryList.remove(at: indexpath.row)
        
        do{
            try context.save()
        }catch{
            print("Error saving in delete Method. \(error)")
        }
        
    }
}
