//
//  ViewController.swift
//  PromiseKit
//
//  Created by Nikolai Krusser on 10.02.2022.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Post {
    let id: Int
    let title: String
    let body: String
}

class ParseData: Operation {
    
    var outputData: [Post] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation,
              let data = getDataOperation.data else { return }
        
        let json = try! JSON(data: data)
        print(json)
        
        let posts: [Post] = json.compactMap {
            let id = $0.1["id"].intValue
            let title = $0.1["title"].stringValue
            let body = $0.1["body"].stringValue
            return Post(id: id, title: title, body: body)
        }
        
        outputData = posts 
    }
}

class ReloadTableControllerOperation: Operation {
    
    var controller: UIViewController
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    override func main() {
        guard let parseData = dependencies.first as? ParseData else { return }
        
//        controller.posts = parseData.outputData
//        controller.tableView.reloadData()
        print(parseData.outputData)
  
  }
}



class ViewController: UIViewController {
    
    //    let blurTreeOperation = BlurImageOperation(inputImage: UIImage(named: "Moscaw")!)
    
    
    @IBOutlet weak var blurImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        requestOperation()
        chainOfOperation()
    }
    
    func chainOfOperation() {
        
        let operationQueue = OperationQueue()
        
        let request = AF.request("https://jsonplaceholder.typicode.com/posts")
        
        let getDataOperation = GetDataOperation(request: request)
        operationQueue.addOperation(getDataOperation)
        
        let parseData = ParseData()
        parseData.addDependency(getDataOperation)
        
        operationQueue.addOperation(parseData)
        let reloadTableControllerOperation = ReloadTableControllerOperation(controller: self)
        
        reloadTableControllerOperation.addDependency(parseData)
        OperationQueue.main.addOperation(reloadTableControllerOperation)
    }
    
    func requestOperation() {
        
        let operationQueue = OperationQueue()
        let request = AF.request("https://jsonplaceholder.typicode.com/posts")
        
        let operation = GetDataOperation(request: request)
        operation.completionBlock = {
            print(operation.data as Any)
        }
        operationQueue.addOperation(operation)
    }
    
}

