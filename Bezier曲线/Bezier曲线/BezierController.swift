//
//  ViewController.swift
//  Bezier曲线
//
//  Created by anjubao on 2017/6/1.
//  Copyright © 2017年 zhang_yan_qing. All rights reserved.
//

import UIKit

let ScreenWith = UIScreen.main.bounds.width

let ScreenHeight = UIScreen.main.bounds.height

class BezierController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationController?.navigationBar.backgroundColor = UIColor.lightGray
        title = "贝塞尔曲线"
        
        btnConstraintW.constant = (ScreenWith - 2 * 10 - 3 * 20) / 4
        
        bezierView.backgroundColor = UIColor.white
        view.addSubview(bezierView)
        bezierView.pointArray = pointArray
        view.sendSubview(toBack: bezierView)
    }
    
    /// 贝塞尔view
    let bezierView = BezierView.init(frame:UIScreen.main.bounds)
    
    /// 初始数据点
    var pointArray:NSMutableArray = {
    
        var mArray = NSMutableArray()
        mArray.addObjects(from: [CGPoint(x:80,y:150),CGPoint(x:120,y:80),CGPoint(x:200,y:99)])
        
        return mArray
    }()
    
    
    @IBOutlet weak var btnConstraintW: NSLayoutConstraint!
    
    
    // MARK: - 添加数据点
    @IBAction func addPoint(_ sender: Any) {
        
        print("添加")
    }

    // MARK: - 删除数据点
    @IBAction func delPoint(_ sender: Any) {
    }
    
    // MARK: - 开始描绘控制点
    @IBAction func start(_ sender: Any) {
    }
    
    // MARK: - 停止描绘控制点
    @IBAction func stop(_ sender: Any) {
    }
    
    
}










