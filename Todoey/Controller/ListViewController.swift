//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import ChameleonFramework

class ListViewController: SwingTableViewController {
    
    var arrList = [Item]()
    var selectedCategory:CategoryItem? {
        didSet {
              loadItem()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
   
    
   
    
    //MARK - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
      
        
    
      
    }
    //MARK: - view WillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        title = selectedCategory?.name
    }
    
    //MARK - tableview numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    //MARK - tableView cellforRowInSection
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let item = arrList[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator
        // value = condition ? true : false
        
        cell.accessoryType  = (item.done == false ) ? .none  : .checkmark
        
        
        if let colour = UIColor.init(hexString: (selectedCategory!.colour!))!.darken(byPercentage: (CGFloat)(indexPath.row)/CGFloat((arrList.count))) {
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            
        }
        
      
        /*
        if item.done == false {
            cell.accessoryType = .none
        }else {
            cell.accessoryType = .checkmark
        }
        */
 
       return cell
    }
    
    
    //MARK - tableView didselected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
       
        
        
        arrList[indexPath.row].done = !arrList[indexPath.row].done
               
               saveItem()
        
             
        
           tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add Item from barButtonItem
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Please adding an item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add an item ", style: .default) { (action) in
            print("succeed!")
            
            let new = Item(context: self.context)
            new.title = textfield.text!
            new.done = false
            new.parentCategory = self.selectedCategory
            self.arrList.append(new)
   
            self.saveItem()
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter an Item here"
            
            textfield = alertTextField
            print("hi you are in textfield here .....")
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK - Save Data
    
    func saveItem(){
       
                  do {
                     
                     try context.save()
                    
                    print("Suceeded in save data from coreData ..")
                      
                  }catch {
                      print("error in Saving Data From coreData\(error)")
                  }
                 
                 
              tableView.reloadData()
    }
  
    
    func loadItem  ( request:NSFetchRequest<Item> = Item.fetchRequest() , predicate:NSPredicate? = nil) {
        

        let categoyPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionPredicate,categoyPredicate])
        }else {
            request.predicate = categoyPredicate
        }
        do {
            
             arrList = try context.fetch(request)
            
        }catch{
            print("Error while Fectching Data From Item Entity \(error)")
        }
        tableView.reloadData()
    }
    override func deleteMethod(at indexpath: IndexPath) {
        context.delete(arrList[indexpath.row])
        arrList.remove(at: indexpath.row)
        
        do{
            try context.save()
        }catch{
            print("Error saving data in delete Method \(error)")
        }
    }
 
}


extension ListViewController:UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
   
       request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
        
        
    
        loadItem(request: request, predicate: predicate)
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
                DispatchQueue.main.async {
                 searchBar.resignFirstResponder()
            }
            
        }
    }
}
