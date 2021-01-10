//
//  ViewController.swift
//  taskApp
//
//  Created by 河崎優人 on 2021/01/07.
//  Copyright © 2021 yuto. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications





class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate{
  
  
   let realm = try! Realm()

    let searchController = UISearchController(searchResultsController: nil)

    var taskArrey = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        navigationItem.searchController = searchController
        
        searchController.searchBar.delegate = self
        
    }
    
  
   
 func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
    
    let predicate = NSPredicate(format: "category contains %@",searchText)
        var cate = realm.objects(Task.self).filter(predicate)
       
    
        
        if searchText.count > 0{
            
            var filterResults = cate.filter
    }
        taskArrey = cate
        tableView.reloadData()
        }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        taskArrey = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    
    
    
 
 
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArrey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let task = taskArrey[indexPath.row]
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = task.category
        
    
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let tTask = self.taskArrey[indexPath.row]
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(tTask.id)])
            
            try!realm.write{
                self.realm.delete(self.taskArrey[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            center.getPendingNotificationRequests{ (requets:[UNNotificationRequest]) in
                for request in requets {
                print("/----")
                print(request)
                print("------/")
                }
            }
            
        }
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputView:inputViewController = segue.destination as! inputViewController
        
        if segue.identifier == "cellSegue"{
            let selectCell = self.tableView.indexPathForSelectedRow
            inputView.taSk = taskArrey[selectCell!.row]
        }else{
            let tasK = Task()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                tasK.id = allTasks.max(ofProperty: "id")! + 1
            }
            inputView.taSk = tasK
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    

    @IBOutlet weak var tableView: UITableView!
    
}

