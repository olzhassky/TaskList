import UIKit
import SnapKit

class ViewController: UIViewController {
     let tableView = UITableView()
     var tableName: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        makeConstraints()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Заметки"
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        addButton.tintColor = .systemRed
    }
    
    @objc private func addButtonTapped() {
        let alertController = UIAlertController(title: "Создать заметку", message:  nil, preferredStyle: .alert)
        alertController.addTextField { textField in
        }
         
        let createAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let tableName = alertController.textFields?.first?.text else { return }
            self.createTable(withName: tableName)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(createAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func createTable(withName name: String) {
        tableName.append(name)
        tableView.reloadData()
        tableView.endUpdates()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tableName[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "house")
        cell.imageView?.tintColor = .systemRed
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            tableName.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
    }
}


private extension ViewController {
    func setupScene() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

