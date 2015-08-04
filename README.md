# CBEditListViewController

A simple, but powerful (probably) UITableViewController that handles CRUD operations.

## Notes

This sample provides a complete create/insert, list, update/change, and delete UITableViewController.
The actions for the CRUD operations can be customized.

## Usage

Swift example with [Realm](http://realm.io) *v0.94.0* database storage.

```swift
import UIKit
import RealmSwift

class GroupsViewController: CBEditListViewController {
    var groups: Results<Group>!
    let realm = Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addListItemViewCell = UITableViewCell(style: .Default, reuseIdentifier: "add")
        addListItemViewCell.textLabel?.text = NSLocalizedString("Add Group", comment: "")
        
        navigationItem.rightBarButtonItem = editButtonItem()
        reloadItems()
    }
    
    override func cellIdentifierAtIndexPath(indexPath: NSIndexPath!) -> String! {
        return "itemcell"
    }
    
    override func configureCell(cell: UITableViewCell!, indexPath: NSIndexPath!) {
        let theCell = cell as! CBEditListViewCell
        theCell.textField?.text = groups[indexPath.row].name
    }
    
    // MARK: - Misc
    
    func reloadItems() {
        groups = realm.objects(Group)
        items = NSMutableArray(array: Array(groups.generate()))
    }
    
    // MARK: - List Actions
    
    override func willRemoveListItem(item: AnyObject!) {
        let group = item as! Group
        
        items.removeObject(group)
        realm.write {
            self.realm.delete(group)
        }
    }
    
    override func didInsertListItemWithName(name: String!) {
        let group = Group()
        group.name = name
        
        items.addObject(group)
        realm.write {
            self.realm.add(group, update: false)
        }
    }
    
    override func didChangeListItem(item: AnyObject!, toName name: String!) {
        let group = item as! Group
        
        realm.write {
            group.name = name
        }
    }
    
}

```
