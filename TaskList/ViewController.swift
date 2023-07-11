import UIKit
import SnapKit




class ViewController: UIViewController, UISearchResultsUpdating {
    var task: TaskComposite?
    
    let tableView = UITableView()
    var tableName: [String] = []
    var filteredData: [String] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    init(task: TaskComposite) {
        self.task = task
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
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
        let alertController = UIAlertController(title: "Сохранить", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        let action = UIAlertAction(title: "Добавить", style: .default, handler: { (action) -> Void in
            if let tableName = (alertController.textFields?[0] as? UITextField)?.text {
                let newTask = Task(parent: self.task)
                newTask.name = tableName
                self.task?.children.append(newTask)
                self.createTable(withName: tableName)
            
            }
        })
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(action)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func createTable(withName name: String) {
        tableName.append(name)
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        filteredData = tableName.filter { $0.localizedCaseInsensitiveContains(searchText) }
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        task?.children.count
        if isFiltering {
            return filteredData.count
        } else {
            return tableName.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = task?.children[indexPath.row].name
        let rowData: String
        if isFiltering {
            rowData = filteredData[indexPath.row]
        } else {
            rowData = tableName[indexPath.row]
        }
        
        cell.textLabel?.text = rowData
        cell.imageView?.image = UIImage(systemName: "house")
        cell.imageView?.tintColor = .systemRed
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subTask = task?.children[indexPath.row]
        let viewController = ViewController(task: subTask!)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            if isFiltering {
                filteredData.remove(at: indexPath.row)
            } else {
                tableName.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

private extension ViewController {
    func setupScene() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !(searchController.searchBar.text ?? "").isEmpty
    }
}
