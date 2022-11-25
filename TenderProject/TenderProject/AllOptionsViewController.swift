import UIKit

class AllOptionsViewController: UIViewController {
    @IBOutlet var nameSurnameLabel: UILabel!
    @IBOutlet var createTenderOutlet: UIButton!
    @IBOutlet var showListOfCreatedTendersOutlet: UIButton!
    @IBOutlet var showListOfActualTendersOutlet: UIButton!
    @IBOutlet var showListOfWinnedTendersOutlet: UIButton!
    @IBOutlet var showMyTendersOutlet: UIButton!
    
    var serverManager:ServerManager = .shared
    
    var showHide:Int?
    var nameSurname: String!
    var dict:[String: String] = [:]
    
    struct Tender: Decodable {
        let name: String
        let id: String
    }
    
    struct ParseForMyTenders: Decodable{
        var tenders: [Tender]
        var messageType: String
        var messageValue: String
    }
    
    struct ParseForListOfCreatedTenders: Decodable{
        var tenders: [Tender]
        var messageType: String
        var messageValue: String
    }
    
    struct ParseForListOfActualTenders: Decodable{
        var tenders: [Tender]
        var messageType: String
        var messageValue: String
    }
    
    struct ParseForListOfWinnedTenders: Decodable{
        var tenders: [Tender]
        var messageType: String
        var messageValue: String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Назад", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
        self.navigationItem.hidesBackButton = true
        
        nameSurnameLabel.text = nameSurname
        
        if showHide == 0{
            showListOfActualTendersOutlet.isHidden = true
            showListOfWinnedTendersOutlet.isHidden = true
            showMyTendersOutlet.isHidden = true
        }else if showHide == 1{
            createTenderOutlet.isHidden = true
            showListOfCreatedTendersOutlet.isHidden = true
        }
       
    }
    
    @IBAction func createTender() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ThirdView") as! CreateTenderViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func showMyTenders(){
        dict = ["Login": login, "Func":"ShowMyTenders"]
        serverManager.receive{[weak self] message in
            self?.varifyDataMyTenders(message)
        }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(dict){
            serverManager.sendData(encodedData)
        }
    }
    
    @IBAction func exit() {
        serverManager.close()
        navigationController?.popToRootViewController(animated: true)
    }
    
    func varifyDataMyTenders(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(ParseForMyTenders.self, from: data){
                if decodedData.messageType == "ListOfMyTenders"{
                    if decodedData.messageValue == "True"{
                        let vc = storyboard?.instantiateViewController(withIdentifier: "MyTenders") as! MyTendersTableViewController
                        vc.listOfMyTenders = decodedData.tenders
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        let alert = UIAlertController(title: "Оповіщення", message: "Упс, схоже  немає  тендерів. Спробуйте пізніше:)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(action)
                        present(alert, animated: true)
                    }
                }
                
            }
        default:
            break
        
        }
    }
    
    @IBAction func showListOfCreatedTenders() {
        dict = ["Login": login, "Func":"ShowListOfCreatedTenders"]
        serverManager.receive{ [weak self] message in
            self?.varifyDataForCreatedTenders(message)
        }
        
        let encoder = JSONEncoder()
        if let enocodedData = try? encoder.encode(dict){
            serverManager.sendData(enocodedData)
        }
        
    }
    
    @IBAction func showListOfActualTenders() {
        dict = ["Login": login, "Func": "ShowListOfActualTenders"]
        serverManager.receive{[weak self] message in
            self?.varifyDataForActualTenders(message)
            
        }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(dict){
            serverManager.sendData(encodedData)
        }
    }
    
    @IBAction func showListOfWinnedTenders() {
        dict = ["Login": login, "Func":"ShowListOfWinnedTenders"]
        serverManager.receive{[weak self] message in
            self?.varifyDataForWinnedTenders(message)
        }
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(dict){
            serverManager.sendData(encodedData)
        }
    }
    
    func varifyDataForCreatedTenders(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(ParseForListOfCreatedTenders.self, from: data){
                if decodedData.messageType == "ListOfCreatedTenders" {
                    if decodedData.messageValue == "True"{
                        let vc = storyboard?.instantiateViewController(withIdentifier: "FirstTableView") as! CreatedTendersTableViewController
                        vc.listOfCreatedTenders = decodedData.tenders
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        let alert = UIAlertController(title: "Оповіщення", message: "Упс, схоже у вас немає створених тендерів. Спробуйте пізніше:)", preferredStyle: .alert)
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
    
    func varifyDataForActualTenders(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(ParseForListOfActualTenders.self, from: data){
                if decodedData.messageType == "ListOfActualTenders"{
                    if decodedData.messageValue == "True"{
                        let vc = storyboard?.instantiateViewController(withIdentifier: "ListOfActualTenders") as! ListOfActualTendersTableViewController
                        vc.listOfActualTenders = decodedData.tenders
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        let alert = UIAlertController(title: "Оповіщення", message: "Упс, схоже  немає актуальних тендерів. Спробуйте пізніше:)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                        alert.addAction(action)
                        present(alert, animated: true)
                    }
                }
                
            }
        default:
            break
        
        }
    }
    
    func varifyDataForWinnedTenders(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(ParseForListOfWinnedTenders.self, from: data){
                if decodedData.messageType == "ListOfWinnedTenders"{
                    if decodedData.messageValue == "True"{
                        let vc = storyboard?.instantiateViewController(withIdentifier: "WinnedTenders") as! WinnedTendersTableViewController
                        vc.listOfWinnedTenders = decodedData.tenders
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else{
                        let alert = UIAlertController(title: "Оповіщення", message: "Упс, схоже у вас ще немає виграних тендерів. Спробуйте пізніше:)", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
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
