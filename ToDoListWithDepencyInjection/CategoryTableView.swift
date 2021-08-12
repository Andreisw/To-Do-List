//
//  CategoryTableView.swift
//  ToDoListWithDepencyInjection
//
//  Created by Andrei Cojocaru on 19.04.2021.
//

import UIKit
import CoreData

class CategoryTableView: UITableViewController {
    
    
   
    
    var category = [Category]()
     var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
    @objc func addNewCategory() {
        
        var myText = UITextField()
        let alert = UIAlertController(title: "Add new Category", message: "Add new", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) {(action) in
            let newCategory = Category(context: self.context)
            newCategory.name = myText.text
            self.category.append(newCategory)
            self.saveCategory()
        
        }
        
        let dismiss = UIAlertAction(title: "Close", style: .default) { (dismiss) in
            alert.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(action)
        alert.addAction(dismiss)
        alert.addTextField { (newCategory) in
            myText = newCategory
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        loadCategory()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewCategory))
    }

    func saveCategory() {
        
        do {
            
            try context.save()
        }
        catch  {
            
            print(error)
            
        }
        
        tableView.reloadData()
    }
        func loadCategory() {
            
            let request : NSFetchRequest<Category> = Category.fetchRequest()
            
            do {
              category = try context.fetch(request)
            }catch {
                print(error)
            }
            tableView.reloadData()
        }
    }

extension CategoryTableView {
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        category.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = category[indexPath.row].name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
           
            
            let vc = FoodTableViewController(selected: category[indexPath.row])
            vc.selectedCategory = category[indexPath.row]
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            context.delete(category[indexPath.row])
            category.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            loadCategory()
            
        }
        
    
    }
    
    
}
