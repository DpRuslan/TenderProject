import UIKit

class CreateTenderViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet var nameOfTenderField: UITextField!
    @IBOutlet var descriptionOfTenderView: UITextView!
    @IBOutlet var priceOfTenderField: UITextField!
    
    func setNullToAllField(){
        nameOfTenderField.text = ""
        descriptionOfTenderView.text = ""
        priceOfTenderField.text = ""
    }
    
    var serverManager:ServerManager = .shared
    var dict:[String: String] = [:]
    
    struct Info: Decodable{
        var messageType: String
        var messageValue: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameOfTenderField.delegate = self
        self.descriptionOfTenderView.delegate = self
        self.priceOfTenderField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameOfTenderField.resignFirstResponder()
        descriptionOfTenderView.resignFirstResponder()
        priceOfTenderField.resignFirstResponder()
         return(true)
     }
    
    @IBAction func createTenderRequest() {
        let textOfPrice = priceOfTenderField.text!
        let texOfName = nameOfTenderField.text!
        let textOfDescription = descriptionOfTenderView.text!
        
        if (textOfPrice == "" || texOfName == "" || textOfDescription == "") {
            let alert = UIAlertController(title: "Оповіщення", message: "Усі поля мають бути заповнені(Мін.Значення дати: 10-10-2022)\nСпробуйте ще раз:)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default){_ in self.setNullToAllField()}
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        if (textOfPrice.isValidPriceOfTender()  && texOfName.containSpecialCharacters(texOfName) == true && textOfDescription.containSpecialCharacters(textOfDescription) == true){
            dict = ["Login":login, "Func": "CreationTender", "NameOfTender": texOfName, "DescriptionOfTender": textOfDescription, "PriceOfTender": textOfPrice]
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
            self?.varifyTenderContent(message)
        }
    }
        
        func varifyTenderContent(_ message: URLSessionWebSocketTask.Message) {
            switch message{
            case .data(let data):
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(Info.self, from: data){
                    if decodedData.messageType == "CreationTender" {
                        if decodedData.messageValue == "True"{
                            let alert = UIAlertController(title: "Оповіщення", message: "Ви успішно створили Тендер", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default){_ in
                                self.navigationController?.popViewController(animated: true)
                            }
                        
                            alert.addAction(action)
                            present(alert, animated: true, completion: nil)
                        }
                        else{
                            
                            let alert = UIAlertController(title: "Оповіщення", message: "Упс, щось пішло не так. Або такий тендер уже створено. Спробуйте ще раз:)", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default){ _ in self.setNullToAllField()
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
