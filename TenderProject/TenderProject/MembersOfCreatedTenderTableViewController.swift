import UIKit
var LocalloginOfMember: String!
class MembersOfCreatedTenderTableViewController: UITableViewController {
    
    var localNameOfMember: String!
    var localId: String!
    struct ParseDetailOfMember: Decodable{
        var messageType: String
        var price: String
        var descriptionOfTender: String
    }
    var serverManager: ServerManager = .shared
    var countOfMembers:[DetailOfCreatedTenderViewController.Members]!
    var dict: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countOfMembers.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath)
        cell.textLabel?.text = countOfMembers[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let member = countOfMembers[indexPath.row]
        LocalloginOfMember = member.loginOfMember
        localNameOfMember = member.name
        localId = member.loginOfMember
        dict = ["TenderId": IdOfCreatedTender, "Func":"Show detail info of member who took part at tender", "LoginOfMember": member.loginOfMember]
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
            if let decodedData = try? decoder.decode(ParseDetailOfMember.self, from: data){
                if decodedData.messageType == "DetailOfMember" {
                
                    let vc = storyboard?.instantiateViewController(withIdentifier: "FifthView") as! DetailOfMemberViewController
                    vc.nameSurname = localNameOfMember
                    vc.price = decodedData.price
                    vc.descriptionTender = decodedData.descriptionOfTender
                    vc.idMember = localId
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        default:
            break
        }
    }
        
}

