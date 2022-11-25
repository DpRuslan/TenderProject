import UIKit
var login: String!
class Regist_Authoriz_ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var password2TextField: UITextField!
    @IBOutlet var password2Label: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surnameLabel: UILabel!
    @IBOutlet var surnameTextField: UITextField!
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
    @IBOutlet weak var segmentControlOutletActor: UISegmentedControl!
    
    var dict:[String: String] = [:]
    var serverManager: ServerManager = .shared

    struct ParseForRegistationOrAuthorization: Decodable{
        var messageType: String
        var messageValue: String
        var name: String
        var surname: String
    }
    
    func setNullToAllFields() {
        loginTextField.text = ""
        passwordTextField.text = ""
        password2TextField.text = ""
        nameTextField.text = ""
        surnameTextField.text = ""
    }
    
    func setNullToNameSurnameLogin() {
        nameTextField.text = ""
        surnameTextField.text = ""
        loginTextField.text = ""
    }
    
    @IBAction func switchSegmentControl(){
        switch segmentControlOutlet.selectedSegmentIndex{
        case 0:
            password2TextField?.isHidden = false
            password2Label.isHidden = false
            nameLabel.isHidden = false
            nameTextField?.isHidden = false
            surnameLabel.isHidden = false
            surnameTextField?.isHidden = false
        case 1:
            password2TextField?.isHidden = true
            password2Label.isHidden = true
            nameLabel.isHidden = true
            nameTextField?.isHidden = true
            surnameLabel.isHidden = true
            surnameTextField?.isHidden = true
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serverManager.createConnection()
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
        self.password2TextField.delegate = self
        self.nameTextField.delegate = self
        self.surnameTextField.delegate = self
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.isSecureTextEntry = true
        password2TextField.textContentType = .oneTimeCode
        password2TextField.isSecureTextEntry = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        serverManager.createConnection()
        setNullToAllFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        loginTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        password2TextField.resignFirstResponder()
         return(true)
     }
    
    @IBAction func processLoginRegistation() {
        if segmentControlOutlet.selectedSegmentIndex == 0 {
            let passwordText = passwordTextField.text
            if (nameTextField.text == "" || surnameTextField.text == "" || loginTextField.text == "" || passwordTextField.text == "" || password2TextField.text == "" || passwordTextField.text != password2TextField.text || passwordText!.count < 7){
                let alert = UIAlertController(title: "Оповіщення", message: "Упс, щось пропустили, або пароль повторно введено неправильно. І пам'ятайте пароль - мінімум 7 символів\nСпробуйте ще раз:)", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default){_ in self.setNullToAllFields()}
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
            
                let nameText = nameTextField.text
                let surnameText = surnameTextField.text
                let loginText = loginTextField.text
            
                if (nameText!.isValidNameAndSurname() && surnameText!.isValidNameAndSurname() && loginText!.isValidLogin() ){
                    if segmentControlOutletActor.selectedSegmentIndex == 0 {
                        
                        dict = ["Actor":"Держ.Установець","Func": "Registation", "Login": loginTextField.text!, "Password": passwordTextField.text!, "Name":nameTextField.text!, "Surname": surnameTextField.text!]
                        let encoder = JSONEncoder()
                        if let encodedRegistation = try? encoder.encode(dict){
                            serverManager.sendData(encodedRegistation)
                        }
                    } else {
                        dict = ["Actor":"Учасник","Func": "Registation", "Login": loginTextField.text!, "Password": passwordTextField.text!, "Name":nameTextField.text!, "Surname": surnameTextField.text!]
                        let encoder = JSONEncoder()
                        if let encodedRegistation = try? encoder.encode(dict){
                            serverManager.sendData(encodedRegistation)
                        }
                     }
                } else{
                    let alert = UIAlertController(title: "Оповіщення", message: "Упс, Ім'я, Прізвище та Логін не можуть містити спеціальних символів, а також Ім'я та Прізвище - кирилиця, Логін - латиниця\nСпробуйте ще раз:)", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "Ok", style: .default){_ in self.setNullToNameSurnameLogin()}
                    alert.addAction(action)
                    present(alert, animated: true, completion: nil)
                }
        }
        
        if segmentControlOutlet.selectedSegmentIndex == 1 {
            if (loginTextField.text == "" || passwordTextField.text == ""){
                let alert = UIAlertController(title: "Оповіщення", message: "Упс, щось пропустили\nСпробуйте ще раз:)", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default){_ in self.setNullToAllFields()}
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            } else {
                dict = ["Func": "Authorization", "Login": loginTextField.text!, "Password": passwordTextField.text!, "Actor": segmentControlOutletActor.titleForSegment(at: segmentControlOutletActor.selectedSegmentIndex)!]
                let encoder = JSONEncoder()
                if let encodedAuthorization = try? encoder.encode(dict){
                    serverManager.sendData(encodedAuthorization)
                }
            }
        }
        serverManager.receive { [weak self] message in
            self?.varifyData(message)
        
        }
    }
    
    func varifyData(_ message: URLSessionWebSocketTask.Message){
        switch message{
        case .data(let data):
            let decoder = JSONDecoder()
            if let decodedData = try? decoder.decode(ParseForRegistationOrAuthorization.self, from: data){
                switch decodedData.messageType{
                case "Registation":
                    switch decodedData.messageValue{
                    case "True":
                        if segmentControlOutlet.selectedSegmentIndex == 0{
                                let alert = UIAlertController(title: "Оповіщення", message: "Ви зареєструвались успішно.\nЛаскаво просимо:)", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default){_ in
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondView") as! AllOptionsViewController
                                vc.showHide = self.segmentControlOutletActor.selectedSegmentIndex
                                vc.nameSurname = decodedData.name + " " + decodedData.surname
                                login = self.loginTextField.text
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                                alert.addAction(action)
                                present(alert, animated: true, completion: nil)
                        }
                    case "False":
                        if segmentControlOutlet.selectedSegmentIndex == 0{
                            let alert = UIAlertController(title: "Оповіщення", message: "Упс, такий користувач вже існує.\nСпробуйте ще раз:)", preferredStyle: .alert)
                        
                            let action = UIAlertAction(title: "Ok", style: .default){_ in self.setNullToAllFields()}
                            alert.addAction(action)
                            present(alert, animated: true, completion: nil)
                        }
                        
                    default:
                        break
                    }
                    
                case "Authorization":
                    switch decodedData.messageValue{
                    case "True":
                        if segmentControlOutlet.selectedSegmentIndex == 1{
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SecondView") as! AllOptionsViewController
                                vc.showHide = self.segmentControlOutletActor.selectedSegmentIndex
                            vc.nameSurname = decodedData.name + " " + decodedData.surname
                            login = self.loginTextField.text
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    case "False":
                        if segmentControlOutlet.selectedSegmentIndex == 1{
                            let alert = UIAlertController(title: "Оповіщення", message: "Упс, щось ввели невірно або такого користувача не існує\nСпробуйте ще раз:)", preferredStyle: .alert)
                        
                            let action = UIAlertAction(title: "Ok", style: .default){_ in self.setNullToAllFields()}
                            alert.addAction(action)
                            present(alert, animated: true, completion: nil)
                        }
                        
                    default:
                        break
                        
                    }
                default:
                    break
                }
                
            }
        case .string(let message):
            print("Got String: \(message)")
        default:
            break
        }
    }
    
   


}

extension String{
    func isValidPriceOfTender() -> Bool {
        let inputRegEx = "^[0-9]+ грн$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with: self)
    }
    
    func isValidNameAndSurname() -> Bool {
        
        let inputRegEx = "^[А-ЯІ]{1,1}[а-яі]{3,60}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with: self)
    }
    
    func isValidLogin() -> Bool {
        let inputRegEx = "^[A-Za-z0-9]{7,60}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@", inputRegEx)
        return inputpred.evaluate(with: self)
    }
    func containSpecialCharacters(_ text: String) -> Bool{
        if (text.contains("!") || text.contains("@") || text.contains("#") || text.contains("$") || text.contains("%") || text.contains("^") || text.contains("&") || text.contains("*") ||  text.contains("_") || text.contains("+") || text.contains("=") || text.contains(";") || text.contains("{") || text.contains("}") || text.contains("[") || text.contains("]") || text.contains("|") || text.contains("/") || text.contains("?") || text.contains("~") || text.contains("`") || text.contains("<") || text.contains(">") ){
            return false
        }else {
            return true
        }
    }
    
}

