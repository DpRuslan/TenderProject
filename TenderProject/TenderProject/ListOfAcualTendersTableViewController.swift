import UIKit

var localNameOfActualTender: String!
var localIdOfActualTender: String!

class ListOfActualTendersTableViewController: UITableViewController {
    
    
    var listOfActualTenders: [AllOptionsViewController.Tender]!
    var dict:[String:String] = [:]
    var serverManager: ServerManager = .shared
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }

   

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfActualTenders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath)
        cell.textLabel?.text = listOfActualTenders[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = listOfActualTenders[indexPath.row]
    
        localNameOfActualTender = model.name
        localIdOfActualTender = model.id
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailOfActualTender") as! DetailOfActualTenderViewController
        
        
        vc.nameOfTender = model.name
        
        dict = ["Login": login, "Func":"Show detail info of current actual Tender", "TenderId": model.id]
        serverManager.receive{ message in
            vc.allTextFields(message)
        }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(dict){
        serverManager.sendData(encodedData)
        }
            
        
        navigationController?.pushViewController(vc, animated: true)
    }

   

}
