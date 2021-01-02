//
//  ViewController.swift
//  MyToDoApp
//
//  Created by Yoshiyasu KO on 2020/12/30.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    var todoList = [String]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let storedToDoList = userDefaults.array(forKey: "todoList") as? [String] {
            todoList.append(contentsOf: storedToDoList)
        }
    }
}

// MARK: - UI

extension ViewController {
    @IBAction func addBarAction(_ sender: Any) {
        let alertController = UIAlertController(title: "ToDoを追加", message: "ToDoを入力してください", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                self.todoList.insert(textField.text!, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                self.userDefaults.setValue(self.todoList, forKey: "todoList")
            }
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        let todoTitle = todoList[indexPath.row]
        cell.textLabel?.text = todoTitle
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            userDefaults.setValue(todoList, forKey: "todoList")
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
}
