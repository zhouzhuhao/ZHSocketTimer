//
//  ViewController.swift
//  ZHSocketTimerDemo
//
//  Created by John on 2019/5/24.
//  Copyright © 2019 John. All rights reserved.
//

import UIKit

import ZHSocketTimer

class ViewController: UIViewController {
	

	var timer:ZHSocketTimer!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		timer = ZHSocketTimer.init(errorCount: 5, timeInterval: 5)
		timer.startPingTimer(sucessBlock: {
			print("ping timer success")
		}) {
			print("ping timer failed")
		}
		
	}

}

