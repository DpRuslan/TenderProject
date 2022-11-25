import UIKit

class DetailOfCreatedTenderViewController: UIViewController {
    var dict: [String:String] = [:]
    var idOfTender: String!
    
    struct AllTextFieldsStruct: Decodable{
        var messageType: String
        var descriptionOfTender: String
        var priceOfTender: String
        var dateOfTender: String
    }
    var nameOfTender: String!
    var serverManager: ServerManager = .shared
    var descriptionOfTender: String!
    
    struct Members:Decodable{
        var name: String
        var loginOfMember: String
    }
    struct CountAndNamesOfMembers: Decodable{
        var messageType: String
        var messageValue: String
        var members: [Members]
    }
    
    @IBOutlet var nameOfTenderField: UITextField!
    @IBOutlet var descriptionOfTenderView: UITextView!
    @IBOutlet var priceOfTenderField: UITextField!
    @IBOutlet var dateOfTenderField: UITextField!
    @IBAction func showListOfMembers(){
        dict = ["Func": "ShowMembersOfTender", "TenderId": idOfTender]
        serverManager.receive{[weak self] message in
            self?.encodeMembers(message)
        }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(dict){
            serverManager.sendData(encodedData)
            
        }
    }
       
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        nameOfTenderField.text = nameOfTender
        nameOfTenderField.isUserInteractionEnabled = false
        
    }
    
    
    func allTextFields(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try?
                decoder.decode(AllTextFieldsStruct.self, from: data){
                if decodedData.messageType == "DetailInfoOfCreatedTender"{
                    descriptionOfTenderView.text = decodedData.descriptionOfTender
                    priceOfTenderField.text = decodedData.priceOfTender
                    dateOfTenderField.text  = decodedData.dateOfTender
                    descriptionOfTenderView.isUserInteractionEnabled = false
                    priceOfTenderField.isUserInteractionEnabled = false
                    dateOfTenderField.isUserInteractionEnabled = false
                    
                    
                }
            }
        default:
            break
                
        }
    }
    
    func encodeMembers(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(CountAndNamesOfMembers.self, from: data){
                if decodedData.messageType == "ListOfMembers"{
                    if decodedData.messageValue == "True"{
                
                    let vc = storyboard?.instantiateViewController(withIdentifier: "SecondTableView") as! MembersOfCreatedTenderTableViewController
                    vc.countOfMembers = decodedData.members
                    self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if decodedData.messageValue == "False1"{
                        let alert = UIAlertController(title: "Оповіщення", message: "Упс, схоже у цього тендера немає учасників . Спробуйте пізніше:)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default){_ in
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: CreatedTendersTableViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                        alert.addAction(action)
                        present(alert, animated: true)
                    }else{
                        let alert = UIAlertController(title: "Оповіщення", message: "Упс, схоже ви уже обрали переможця даного тендеру:)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default){_ in
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: CreatedTendersTableViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                        alert.addAction(action)
                        present(alert, animated: true)
                    }
                }
                
            }
        default:
            break
        }
    }

}
