import UIKit

class DetailOfWinnedTenderViewController: UIViewController {
    @IBOutlet var nameOfTenderField: UITextField!
    @IBOutlet var descriptionOfTenderView: UITextView!
    @IBOutlet var priceOfTenderField: UITextField!
    @IBOutlet var dateOfTenderField: UITextField!
    
    var nameOfTender: String!
    var descriptionOfTender: String!
    var priceOfTender: String!
    var dateOfTender: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameOfTenderField.text = nameOfTender
        descriptionOfTenderView.text = descriptionOfTender
        priceOfTenderField.text = priceOfTender
        dateOfTenderField.text = dateOfTender
        nameOfTenderField.isUserInteractionEnabled = false
        descriptionOfTenderView.isUserInteractionEnabled = false
        priceOfTenderField.isUserInteractionEnabled = false
        dateOfTenderField.isUserInteractionEnabled = false

       
    }
    
}
