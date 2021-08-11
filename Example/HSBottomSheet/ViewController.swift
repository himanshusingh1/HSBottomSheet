//
//  ViewController.swift
//  HSBottomSheet
//
//  Created by Himanshu on 08/11/2021.
//  Copyright (c) 2021 Himanshu. All rights reserved.
//

import UIKit
import HSBottomSheet
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        let vc = storyboard?.instantiateViewController(identifier: "A")
        self.showBottomSheet(masterViewController: vc!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

