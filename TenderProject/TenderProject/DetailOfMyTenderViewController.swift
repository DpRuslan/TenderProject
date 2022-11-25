import UIKit

class DetailOfMyTenderViewController: UIViewController {
    @IBOutlet var descriptionOfTenderView: UITextView!
    @IBOutlet var  priceToDoField: UITextField!
    @IBOutlet var dateOfTenderField: UITextField!
    @IBOutlet var nameOfTenderField: UITextField!
    
    var nameOfTender: String!
    var descriptionOfTender: String!
    var priceOfTender: String!
    var dateOfTender: String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfTenderField.text = nameOfTender
        descriptionOfTenderView.text = descriptionOfTender
        priceToDoField.text = priceOfTender
        dateOfTenderField.text = dateOfTender
        
    }
    

  

}
