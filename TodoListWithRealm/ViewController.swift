//
//  ViewController.swift
//  CoreDataApp
//
//  Created by Zahra Alizada on 15.05.24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var items = [ToDoList]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
    }
    
    func fetchItems() {
        do {
            items = try context.fetch(ToDoList.fetchRequest())
            table.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveItem(text: String) {
        do {
            let model = ToDoList(context: context)
            model.title = text
            try context.save()
            fetchItems()
        } catch {
            print(error.localizedDescription)
        }
    }

    func deleteItem(index: Int) {
        do {
            context.delete(items[index])
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func addBtnTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Enter new item", message: "", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Add new item"
        }
        let ok = UIAlertAction(title: "Add", style: .default) { _ in
            let text = alert.textFields?[0].text ?? ""
            self.saveItem(text: text)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell" , for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            table.beginUpdates()
            
            deleteItem(index: indexPath.row)
            items.remove(at: indexPath.row)
            table.deleteRows(at: [indexPath], with: .fade)
            
            table.endUpdates()
        }
            
    }
    
    
    
}
