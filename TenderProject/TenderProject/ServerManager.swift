import Foundation

final class ServerManager: NSObject, URLSessionWebSocketDelegate{
    static let shared: ServerManager = .init()
    
    var webSocket: URLSessionWebSocketTask?
  
   
    private override init(){
        
    }
    
    
    func createConnection(){
        let session = URLSession(configuration: .default,
                                 delegate: self,
                                 delegateQueue: OperationQueue()
        )
        
        let url = URL(string: "ws://127.0.0.1:3000")
        webSocket = session.webSocketTask(with: url!)
        webSocket?.resume()
    }
    
    func receive(completion: ((URLSessionWebSocketTask.Message) -> Void)? = nil) {
        webSocket?.receive(completionHandler: {result in
            DispatchQueue.main.async  {
                switch result{
                case .success(let message):
                    completion?(message)
                case .failure(let error):
                    print("Received error, response from server: \(error)")
                }
            }
           
        })
        
    }
    
    func sendData(_ data: Data) {
        webSocket?.send(.data(data), completionHandler: { error in
            if let error = error {
                print("Помилка при надсиланні даних \(error.localizedDescription)")
            }
        })
    }
    func close(){
        webSocket?.cancel(with: .goingAway, reason: "Pressed EXIT".data(using: .utf8))
    }
}
