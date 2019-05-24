//
//  ZHSocketTimer.swift
//  ZHSocketTimer_Example
//
//  Created by John on 2019/5/24.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

// 心跳的timer
typealias PingCallBackBlock = ()->()

class ZHSocketTimer: NSObject {
	
	//  心跳异常次数
	var errorCount:Int = 2
	var startCount = 0
	
	//	心跳间隔 默认是10
	var timeInterval:TimeInterval = 10
	
	var gcdTimer:DispatchSourceTimer?
	
	
	var pingSuccessBlock:PingCallBackBlock?
	var pingFailBlock:PingCallBackBlock?
	
	init(errorCount count:Int,timeInterval:TimeInterval) {
		super.init()
		self.errorCount = count>0 ? count:self.errorCount
		self.timeInterval = timeInterval>0 ? timeInterval:self.timeInterval
	}
	
	// 收到心跳或者消息后置零
	func pingTimerDecreaseCount() -> Void {
		self.startCount = 0
	}
	
	
	func startPingTimer(sucessBlock:@escaping PingCallBackBlock,failBlock:@escaping PingCallBackBlock) -> Void {
		
		self.pingSuccessBlock = sucessBlock
		self.pingFailBlock = failBlock
		startCount = 0
		loadTimer()
		fireTimer()
		
	}
	
	func loadTimer() -> Void {
		
		// 先移除，然后在创建
		if gcdTimer == nil {
			gcdTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global(qos: .default))
			gcdTimer?.schedule(deadline: .now(), repeating: timeInterval, leeway: .seconds(0))
			weak var weakSelf:ZHSocketTimer? = self
			gcdTimer?.setEventHandler(handler: {
				weakSelf?.pingTimer()
			})
		}
		
	}
	
	@objc func pingTimer(){
		
		startCount+=1
		if startCount>errorCount{
			// 心跳异常 -- 关闭timer
			self.stopTimer()
			self.pingFailBlock?()
		}else{
			self.pingSuccessBlock?()
		}
	}
	
	func fireTimer() -> Void {
		gcdTimer?.resume()
		
	}
	
	func stopTimer() -> Void {
		gcdTimer?.suspend()
	}
	
	// 重新登录的时候需要用到 -- 重连作用
	func resetStartCount() -> Void {
		startCount = 0
	}
	
	deinit {
		gcdTimer?.cancel()
		gcdTimer = nil
	}
}



