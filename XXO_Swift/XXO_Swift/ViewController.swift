//
//  ViewController.swift
//  XXO_Swift
//
//  Created by Paul Jacobs on 1/25/15.
//  Copyright (c) 2015 Paul Jacobs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var turnIndicatior: UILabel!
    @IBOutlet var resetButton: UIButton!
    
    @IBOutlet var A0: UIImageView!
    @IBOutlet var A1: UIImageView!
    @IBOutlet var A2: UIImageView!

    @IBOutlet var B0: UIImageView!
    @IBOutlet var B1: UIImageView!
    @IBOutlet var B2: UIImageView!

    @IBOutlet var C0: UIImageView!
    @IBOutlet var C1: UIImageView!
    @IBOutlet var C2: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

