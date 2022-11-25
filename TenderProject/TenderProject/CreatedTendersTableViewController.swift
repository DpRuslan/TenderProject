import UIKit
var IdOfCreatedTender: String!
class CreatedTendersTableViewController: UITableViewController {
    var listOfCreatedTenders: [AllOptionsViewController.Tender]!
    var dict:[String:String] = [:]
    
    var serverManager: ServerManager = .shared
   
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCreatedTenders.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath)
        cell.textLabel?.text = listOfCreatedTenders[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "FourthView") as! DetailOfCreatedTenderViewController
        
        let model = listOfCreatedTenders[indexPath.row]
        vc.nameOfTender = model.name
        vc.idOfTender = model.id
        IdOfCreatedTender = model.id
        dict = ["Func":"Show detail info of current created Tender", "TenderId": model.id]
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
