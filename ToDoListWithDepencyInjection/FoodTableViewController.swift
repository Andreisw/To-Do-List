//
//  FoodTableViewController.swift
//  ToDoListWithDepencyInjection
//
//  Created by Andrei Cojocaru on 19.04.2021.
//

import UIKit
import CoreData

class FoodTableViewController: UITableViewController {
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var food = [Food]()
    
    var selectedCategory: Category {
        
        
       
        didSet {
            print("Category Selected")
            loadData()
        }
    }
    
    init(selected:Category) {
        
        self.selectedCategory = selected
        super.init(style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addNewFood() {
        
        
        var foodTextfield = UITextField()
        let alert = UIAlertController(title: "Add new Food", message: "Add", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newFood = Food(context: self.context)
            newFood.name = foodTextfield.text
            newFood.parentCategory = self.selectedCategory
            
            self.food.append(newFood)
            
            self.saveData()
        }
        
        alert.addAction(action)
        alert.addTextField { (addText) in
            
            foodTextfield = addText
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFood))
        
      
    }
    
    func saveData() {
        
        do {
            
            try context.save()
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadData(predicate:NSPredicate? = nil) {
        
        let requestPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory.name!)
        let request :NSFetchRequest<Food> = Food.fetchRequest()
        request.predicate = requestPredicate
        do {
        
            
            food = try context.fetch(request)
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
}

extension FoodTableViewController {
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        food.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = food[indexPath.row].name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            context.delete(food[indexPath.row])
            food.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
