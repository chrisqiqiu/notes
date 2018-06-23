//
//  ViewController.swift
//  Plain Old Notes
//
//  Created by Chris Qiu on 18/6/18.
//  Copyright © 2018 Chris Qiu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var Table: UITableView!
    var data:[String] = []
    var fileURL:URL!
    var selectedRow:Int = -1
    var newRowText:String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        Table.dataSource = self
        Table.delegate = self
        
        self.title="Notes"
        self.navigationController?.navigationBar.prefersLargeTitles=true
        self.navigationItem.largeTitleDisplayMode = .never
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        self.navigationItem.rightBarButtonItem=addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        let baseURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        fileURL = baseURL.appendingPathComponent("notes.txt")
        
        load()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if selectedRow == -1 {
            return 
        }
        data[selectedRow]=newRowText
        if newRowText == "" {
            data.remove(at: selectedRow)
        }
        Table.reloadData()
        save()
    }
    
    @objc func addNote(){
        
        if Table.isEditing {
            return
        }
        
        let name:String = ""
        data.insert(name, at:0)
        let indexPath:IndexPath = IndexPath(row: 0, section: 0 )
        Table.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        Table.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
    
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        Table.setEditing(editing, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        data.remove(at:indexPath.row)
        Table.deleteRows(at: [indexPath], with:.fade)
        save()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        selectedRow = Table.indexPathForSelectedRow!.row
        detailView.masterView=self
        detailView.setText(t: data[selectedRow])
    }
    
    func save(){
        //UserDefaults.standard.set(data, forKey: "notes")
        let a = NSArray(array: data)
        do {
            try a.write(to: fileURL)
        } catch {
            print("error writing file")
        }
    }
    
    func load(){
        if let loadedData:[String]=NSArray(contentsOf:fileURL) as? [String]
            //UserDefaults.standard.value(forKey:"notes") as? [String]
        {
            data=loadedData
            Table.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

