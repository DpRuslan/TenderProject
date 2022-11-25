import UIKit

class DetailOfActualTenderViewController: UIViewController {
    @IBOutlet var descriptionOfTenderView: UITextView!
    @IBOutlet var  priceOfTenderField: UITextField!
    @IBOutlet var dateOfTenderField: UITextField!
    @IBOutlet var nameOfTenderField: UITextField!
    @IBAction func takePartIn(){
        let vc = storyboard?.instantiateViewController(withIdentifier: "TakePart") as! TakePartInTenderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    var nameOfTender: String!
    
    struct AllTextFieldsStruct: Decodable{
        var messageType: String
        var descriptionOfTender: String
        var priceOfTender: String
        var dateOfTender: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        nameOfTenderField.text = nameOfTender

    }
    
    func allTextFields(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try?
                decoder.decode(AllTextFieldsStruct.self, from: data){
                if decodedData.messageType == "DetailInfoOfActualTender"{
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
    

    

}
