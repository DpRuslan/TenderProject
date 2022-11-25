//
//  MyTendersTableViewController.swift
//  TenderProject
//
//  Created by Ruslan Yarkun on 25.10.2022.
//

import UIKit

class MyTendersTableViewController: UITableViewController {
    var LocalNameOfTender: String!
    var listOfMyTenders: [AllOptionsViewController.Tender]!
    var dict:[String:String] = [:]
    var serverManager: ServerManager = .shared
    
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

    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listOfMyTenders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTenderCell", for: indexPath)
        cell.textLabel?.text = listOfMyTenders[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = listOfMyTenders[indexPath.row]
        LocalNameOfTender = model.name
        dict = ["Login": login, "Func":"Show detail info of my Tender", "TenderId": model.id]
        serverManager.receive{ message in
            self.varifyData(message)
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
            if let decodedData = try? decoder.decode(AllTextFieldsStruct.self, from: data){
                if decodedData.messageType == "DetailInfoOfMyTender"{
                    let vc = storyboard?.instantiateViewController(withIdentifier: "MyTenderView") as! DetailOfMyTenderViewController
                    vc.descriptionOfTender = decodedData.descriptionOfTender
                    vc.priceOfTender = decodedData.priceOfTender
                    vc.dateOfTender = decodedData.dateOfTender
                    vc.nameOfTender = LocalNameOfTender
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        default:
            break
        }
    }

   
}
