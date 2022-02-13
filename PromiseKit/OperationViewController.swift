//
//  OperationViewController.swift
//  PromiseKit
//
//  Created by Nikolai Krusser on 11.02.2022.
//

import UIKit

class OperationViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        simpleCase()
    }

    func simpleCase() {
//        DispatchQueue.global().async {
//            print(Thread.current)
//            //            Processing
//            DispatchQueue.main.async {
//
//                //                 UI
//                print(Thread.current)
//            }
//        }
        
        let queue = OperationQueue()
        
        queue.addOperation {
            
            let summ = 3 + 7
            let stringSumm = String(describing: summ)
            print("Processing")
            print(Thread.current)
            
            OperationQueue.main.addOperation { [weak self] in
                
                self?.label.text = stringSumm
                print("Main thread operation")
                print(Thread.current)
            }
        }
    }
}
