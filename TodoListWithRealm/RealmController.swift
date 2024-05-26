//
//  RealmController.swift
//  CoreDataApp
//
//  Created by Zahra Alizada on 17.05.24.
//

import UIKit
import RealmSwift

class TodoListRealm: Object {
    @Persisted var title: String
}

class RealmController: UIViewController {

    @IBOutlet weak var tableRealm: UITableView!
    
   var items = [TodoListRealm]()
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Realm"
        if let url = realm.configuration.fileURL {
            print(url)
        }
        getItems()
    }
    
    func deleteItem(index: Int) {
        do {
            let todoToDelete = items[index]
            try! realm.write {
                realm.delete(todoToDelete)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getItems() {
        items.removeAll()
        let data = realm.objects(TodoListRealm.self)
        items.append(contentsOf: data)
        tableRealm.reloadData()
    }
    
    func saveItem(text: String) {
        do {
            let model = TodoListRealm()
            model.title = text
            try realm.write {
                realm.add(model)
                items.append(model)
                tableRealm.insertRows(at: [IndexPath(row: items.count-1, section: 0)], with: .fade)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addBarButton(_ sender: Any) {
        
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

extension RealmController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RealmCell" , for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
}

extension RealmController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableRealm.beginUpdates()
            
            deleteItem(index: indexPath.row)
            items.remove(at: indexPath.row)
            tableRealm.deleteRows(at: [indexPath], with: .fade)
            
            tableRealm.endUpdates()
        }
    }
}
