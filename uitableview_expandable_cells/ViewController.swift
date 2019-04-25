import UIKit

struct Item {
    let text: String
    var subItems: [String]?
    var isExpanded = false
    init(_ text: String, items: [String]? = nil) {
        self.text = text
        self.subItems = items
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let imgOpen = UIImage(named: "open")
    private let imgClose = UIImage(named: "close")

    private var dataSource = [Item]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "groupCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        var items = [Item]()
        items.append(Item("HOME"))
        items.append(Item("ABOUT US"))
        items.append(Item("OUR PROJECTS", items: ["Project-1", "Project-2", "..."]))
        items.append(Item("BAHRIA TOWN PHASE 1 - 7"))
        items.append(Item("BAHRIA TOWN PHASE 8"))
        self.dataSource = items
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let item = self.dataSource[section]
        if item.isExpanded, let count = item.subItems?.count {
            return count + 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let item = self.dataSource[indexPath.section]

            let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
            var imageView: UIImageView?
            if indexPath.row > 0, let text = item.subItems?[indexPath.row - 1] {
                cell.textLabel?.text = text
            } else {
                cell.textLabel?.text = item.text
                if item.subItems != nil {
                    imageView = UIImageView(image: item.isExpanded ? self.imgClose : self.imgOpen)
                }
            }
            cell.accessoryView = imageView

            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.dataSource[indexPath.section]
        if indexPath.row == 0 && item.subItems != nil {
            self.dataSource[indexPath.section].isExpanded = !item.isExpanded
            let indexSet = IndexSet(integer: indexPath.section)
            tableView.reloadSections(indexSet, with: .automatic)
        } else {
            // non-expandable menu item tapped
        }
    }
}
