//
//  ViewController.swift
//  Assignment4
//
//  Created by Elias Aguilera Yambay on 2020-07-23.
//  Copyright © 2020 Elias Aguilera Yambay. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   

    
    @IBOutlet weak var myTableView: UITableView!
    let  context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Student]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        fetchStudent()
        
    }
    
    func fetchStudent() {
            //fetch from core data
        do{
            self.items = try context.fetch(Student.fetchRequest())
            myTableView.reloadData()
        }
        catch{
            
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = myTableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        let stud = items![indexPath.row]
        
        cell.textLabel?.text = stud.name
        return cell
        
       }
       
    
   
    @IBAction func plusAdd(_ sender: UIBarButtonItem) {
        // Alert
       let alert = UIAlertController(title: "Add Student", message: "What is your student name", preferredStyle: .alert)
        alert.addTextField()
        let addButton = UIAlertAction(title: "Add", style: .default) {(action) in
            let textField = alert.textFields![0]
            
            //create
                   let newStudent = Student(context: self.context)
                   newStudent.name = textField.text
                   newStudent.studentnumber = 546866
                   newStudent.college = "Georgian College"
                   newStudent.city = "Barrie"
                   
                   
                   do {     //save
                       try self.context.save()}
                   catch {
                       
                   }
                   //Refetch data
            self.fetchStudent()
                          
                       
        }
             alert.addAction(addButton)
             present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       let action = UIContextualAction(style: .destructive, title: "Delete"){ (action, view, completionHandler) in
        //Which Student remove
        let studentToRemove = self.items![indexPath.row]
        // Remove student
        self.context.delete(studentToRemove)
        // Save the data
        do {     //save
            try self.context.save()}
            catch {
                            
                }
        // Re-fetch the data
        self.fetchStudent()
        
        }
        return UISwipeActionsConfiguration(actions:[action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Select student
        
        let student = items![indexPath.row]
        // Create Alert
        let alert = UIAlertController(title: "Update", message: "Edit Student Name", preferredStyle: .alert)
        alert.addTextField()
        let textField = alert.textFields![0]
        textField.text = student.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default){
            (action) in let textField = alert.textFields![0]
            // Edit name property
            
            student.name = textField.text
            
            //save
            do {     //save
                                try self.context.save()}
                            catch {
                                
                            }
            //Re-Fetch
            self.fetchStudent()
        }
        alert.addAction(saveButton)
        
        // Alert
        self.present(alert, animated: true, completion: nil)
    }
    
}

