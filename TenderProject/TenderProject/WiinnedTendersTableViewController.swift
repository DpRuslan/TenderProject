import UIKit

class WinnedTendersTableViewController: UITableViewController {
    
    struct ParseDetailOfWinnedTender: Decodable{
        var messageType: String
        var descriptionOfTender: String
        var priceOfTender: String
        var dateOfTender: String
    }
    var serverManager: ServerManager = .shared
    var dict: [String:String] = [:]
    var listOfWinnedTenders: [AllOptionsViewController.Tender]!
    var name: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black

      
    }

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfWinnedTenders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath)
        cell.textLabel?.text = listOfWinnedTenders[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = listOfWinnedTenders[indexPath.row]
        name = model.name
        dict = ["Login": login, "Func":"Show detail info of winned Tender","TenderId": model.id]
        serverManager.receive{[weak self] message in
            self?.varifyData(message)
        }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(dict){
            serverManager.sendData(encodedData)
        }
    }
    
    func varifyData(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(ParseDetailOfWinnedTender.self, from: data){
                if decodedData.messageType == "DetailInfoOfWinnedTender"{
                    let vc = storyboard?.instantiateViewController(withIdentifier: "DetailOfWinnedTender") as! DetailOfWinnedTenderViewController
                    vc.descriptionOfTender = decodedData.descriptionOfTender
                    vc.priceOfTender = decodedData.priceOfTender
                    vc.dateOfTender = decodedData.dateOfTender
                    vc.nameOfTender = name
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        default:
            break
        }
    }
    

}

