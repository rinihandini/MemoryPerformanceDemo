//
//  ViewController.swift
//  MemoryPerformanceDemo
//
//  Created by Rini Handini on 04/09/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton()
        button.setTitle("Tap Me", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        view.addSubview(button)
    }

    @objc private func didTapButton() {
        let vc = SecondVC()
        present(vc, animated: true)
    }
}

class MyView: UIView {
    // var vc: UIViewController // Strong reference to create a memory leak
    weak var vc: UIViewController? // Use a weak reference to avoid retain cycle

    init(vc: UIViewController) {
        self.vc = vc
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class SecondVC: UIViewController {
    var myView: MyView?
    var largeArray: [Int] = Array(1...1000000) // Large array to create performance issue

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        myView = MyView(vc: self)
        
        // Introduce a performance issue
        performHeavyComputation()
    }
    
    // Method to introduce a performance bottleneck
    func performHeavyComputation() {
        // Simulate a heavy computation task
        /*
        for _ in 0..<10000 {
            largeArray.sort(by: >)
        }
        print("Heavy computation completed")
        */
        
        // Fix the performance issue by moving the heavy computation to a background thread
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            for _ in 0..<10000 {
                self.largeArray.sort(by: >)
            }
            print("Heavy computation completed")
        }
    }
}
