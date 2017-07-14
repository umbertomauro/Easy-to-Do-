//
//  ListController.swift
//  Easy To Do
//
//  Created by Umberto Mauro on 12/07/17.
//  Copyright © 2017 Umberto Mauro. All rights reserved.
//

import UIKit

class ListController: UITableViewController {

    var storage : [ToDoModel] = [ToDoModel(nome:"Pizza"), ToDoModel(nome:"Birra")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
                    //questo serve per editare le componenti del array ( solo cancellare e editare )
      
            if let data  = UserDefaults.standard.data(forKey: "salvataggio") {
                
                storage = NSKeyedUnarchiver.unarchiveObject(with: data) as! [ToDoModel]
            }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    @IBAction func aggiungi(_ sender: UIBarButtonItem) {
    
        let fieldAlert = UIAlertController(title: "Aggiungi",
                                           message: "Prodotto o Commissione",
                                           preferredStyle: .alert)
        //questo serve per  alert controller
        
        fieldAlert.addTextField( configurationHandler: { textField in
            textField.placeholder = "Scrivi qualcosa"
            textField.isSecureTextEntry = false
        } )
        
                //Clouser = questo viene eseguito dopo, quando è il momento giusto per il textField ovvero il tipo di testo ( tastiera normale, numerica )
        
        fieldAlert.addAction( UIAlertAction(title: "Annulla", style: .cancel, handler: nil) )
        
        fieldAlert.addAction( UIAlertAction(title: "Inserisci", style: .default, handler: { (action) in
            
            // aggiungi qui il codice che deve essere eseguito quando viene premuto il pulsante
           
            if let fieldsTest = fieldAlert.textFields,
            //testiamo di avere il field
                let field = fieldsTest.first,
            //testiamo che ce ne sia almeno 1
                    let textOk = field.text,
            //testiamo variabile test non sia nil ovvero che sta bene
                        textOk.isEmpty == false {
              //testiamo infine che non sia vuota ovvero che sia piena
                
                
                
                let todo = ToDoModel(nome: textOk)
                    //Nuova istanza se il pulsante va OK
                            self.storage.insert(todo, at:0)
                                //se va bene la butta al primo posto dell array
                                    self.tableView.reloadData()
                                        //ci carica l istanza cosi ci fa il reload facendolo uscire ovvero SALVATAGGIO
                                            self.salva()
                                                    //salviamo il tutto
            
            }
        }) )
        
        present(fieldAlert, animated: true, completion: nil)
        
    }
    
    func salva() {
        //salvare la funzione così possiamo richiamarla tante volte
                let data = NSKeyedArchiver.archivedData(withRootObject: storage)
                    //cosi archiamo in data l arry che noi abbiamo chiamato storage
                        UserDefaults.standard.set(data, forKey: "salvataggio")
                            //l abbiamo archiavato sotto la voce salvataggio
                                UserDefaults.standard.synchronize()
                                    //questo lo obbliga a salvare le preferenze 
    
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return storage.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .none
          // azzerrare la cell
    
        let todo = storage[indexPath.row]
        cell.textLabel?.text = todo.nome
        
        if todo.fatto == true {
            cell.accessoryType = .checkmark
                    // se la condizione e vera toglie il checkmark
        }
            return cell
    }
    

    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //sarebbe quando vuoi eliminare dittamente dalla cella ovvero scorrendo verso sinistra
           if editingStyle == .delete {
                // Delete the row from the data source
                        storage.remove(at: indexPath.row)
                            //scrivere prima che deve eliminare le celle dalla nostra array
                                    salva()
                                        //poi salviamo
                                            tableView.deleteRows(at: [indexPath], with: .fade)
                                                    //eseguiamo il codice di elimare dato da apple
        }    
    }

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
                    //attivazione della funzione che ci permette di riodinare la celle ( con le tre liniette )
        
        storage.swapAt(fromIndexPath.row, to.row)
                //attivare questo per riordinare
                    salva()
                        //infine salvarlo
    }
 

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
            //questo serve a riordinare la lista
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let todo = storage[indexPath.row]
            
            //NOOB
            if todo.fatto == false {
                todo.fatto = true
                cell.accessoryType = .checkmark
            } else {
                todo.fatto = false
                cell.accessoryType = .none
            }
                    salva()
            // questo serve a far marcare le cose fatte  (noob) 
            
            
            //PRO
            //todo.fatto = !todo.fatto
            //cell.accessoryType = todo.fatto == true ? .checkmark : .none
            
        }
    }
    
    

}
