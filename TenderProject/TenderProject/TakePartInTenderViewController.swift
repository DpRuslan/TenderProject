import UIKit

class TakePartInTenderViewController: UIViewController {
    var Id: String!
    var Name: String!
    
    
    
    var serverManager:ServerManager = .shared
    var dict:[String: String] = [:]
    
    @IBOutlet var priceToDo: UITextField!
    @IBOutlet var descriptionOfTenderView: UITextView!
    
    func setNullToAllField(){
        descriptionOfTenderView.text = ""
        priceToDo.text = ""
    }
    
    struct Info: Decodable{
        var messageType: String
        var messageValue: String
    }
    
    @IBAction func requestForTakingPart(){
        let textOfPrice = priceToDo.text!
        let textOfDescription = descriptionOfTenderView.text!
        
        if (textOfPrice == ""  || textOfDescription == "") {
            let alert = UIAlertController(title: "Оповіщення", message: "Усі поля мають бути заповнені(Мін.Значення дати: 10-10-2022)\nСпробуйте ще раз:)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){_ in self.setNullToAllField()}
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        if (textOfPrice.isValidPriceOfTender()  && textOfDescription.containSpecialCharacters(textOfDescription) == true){
            dict = ["Login":login, "Func": "RequestForTakingPart", "DescriptionOfTender": textOfDescription, "PriceToDo": textOfPrice, "IdTender": localIdOfActualTender, "NameOfTender": localNameOfActualTender]
            let encoder = JSONEncoder()
            if let encodedData = try? encoder.encode(dict){
            serverManager.sendData(encodedData)
            
                
            }
            
        } else{
            let alert = UIAlertController(title: "Оповіщення", message: "Усі поля мають бути заповнені згідно з вимогами, а також не містити спеціальних символів\nСпробуйте ще раз:)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){_ in self.setNullToAllField()}
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
        serverManager.receive{ [weak self] message in
            self?.varifyContent(message)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
     
       
    }
    
    func varifyContent(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(Info.self, from: data){
                if decodedData.messageType == "RequestForTakingPart" {
                    if decodedData.messageValue == "True"{
                        let alert = UIAlertController(title: "Оповіщення", message: "Ви успішно взяли участь у Тендері", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default){_ in
                            for controller in self.navigationController!.viewControllers as Array {
                                if controller.isKind(of: AllOptionsViewController.self) {
                                    self.navigationController!.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                    
                        alert.addAction(action)
                        present(alert, animated: true, completion: nil)
                    }
                }
                
            }
        default:
            break
        }
        
    }
    

}

