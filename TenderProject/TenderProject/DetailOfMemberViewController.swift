import UIKit

class DetailOfMemberViewController: UIViewController {
    var serverManager: ServerManager = .shared
    var dict: [String: String] = [:]
    struct ParseChosenWinner: Decodable{
        var messageType: String
        var messageValue: String
    }
    @IBOutlet var nameSurnameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionOfTender: UITextView!
    @IBAction func chooseAsWinner(){
        serverManager.receive{[weak self] message in
            self?.varifyData(message)
        }
        dict = ["TenderId": IdOfCreatedTender, "Func":"Choose Winner", "LoginOfMember": LocalloginOfMember]
        let encoder = JSONEncoder()
        
        if let encodedData = try? encoder.encode(dict){
            serverManager.sendData(encodedData)
        }
    }
    var idMember: String!
    var nameSurname: String!
    var price: String!
    var descriptionTender: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameSurnameLabel.text = nameSurname
        priceLabel.text = price
        descriptionOfTender.text = descriptionTender
        descriptionOfTender.isUserInteractionEnabled = false
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black

     
    }
    
    func varifyData(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(ParseChosenWinner.self, from: data){
                if decodedData.messageType == "Choose Winner"{
                    if decodedData.messageValue == "True"{
                        let alert = UIAlertController(title: "Оповіщення", message: "Ви успішно обрали переможця:)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default){_ in
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: AllOptionsViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                        alert.addAction(action)
                        present(alert, animated: true)
                    }else{
                        let alert = UIAlertController(title: "Оповіщення", message: "Упс, щось трапилось. Спробуйте пізніше:)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
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
