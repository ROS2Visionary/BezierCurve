//
//  BezierView.swift
//  Bezier曲线
//
//  Created by anjubao on 2017/6/1.
//  Copyright © 2017年 zhang_yan_qing. All rights reserved.
//

import UIKit

class BezierView: UIView {
    
    /// 数据点
    var pointArray:NSMutableArray?{
        
        didSet{
            // 重绘
            setNeedsDisplay()
            // 添加小圆圈
            creatPoint()
        }
    }
    
    
    override func draw(_ rect: CGRect) {
        
        guard pointArray != nil else {
            return
        }
        
        // 绘制初始曲线
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addLines(between: pointArray as! [CGPoint])
        ctx?.strokePath()
        
        
    }
    
}

// MARK: - 计算控制点
extension BezierView {
    
    fileprivate func calculateCoordinates() {
        
    }
}


// MARK: - 小圆圈相关
extension BezierView {
    
    // MARK: - 创建小圆圈
    fileprivate func creatPoint(){
        
        for i in 0..<(pointArray?.count)! {
            
            let center = pointArray?[i] as! CGPoint
            
            // 定义小圆圈
            let dot = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
            dot.layer.cornerRadius = 5
            dot.layer.borderWidth = 1
            dot.layer.borderColor = UIColor.lightGray.cgColor
            dot.tag = i
            dot.isUserInteractionEnabled = true
            
            // 添加圆圈标记
            let textLB = UILabel(frame: CGRect(x: 10, y: 0, width: 20, height: 10))
            textLB.text = "P" + String(i)
            textLB.font = UIFont.systemFont(ofSize: 10.0)
            dot.addSubview(textLB)
            
            addSubview(dot)
            dot.center = center
            
            // 添加手势
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(movePoint(gesture:)))
            longPressGesture.minimumPressDuration = 0.1
            dot.addGestureRecognizer(longPressGesture)
        }
    }
    
    // MARK: - 监听手势改变小圆圈坐标
    @objc fileprivate func movePoint(gesture:UIGestureRecognizer) {
        
        switch gesture.state {
            
        case .changed:
            // 改变center
            gesture.view?.center = gesture.location(in: self)
            pointArray?.removeObject(at: (gesture.view?.tag)!)
            pointArray?.insert(gesture.location(in: self), at: (gesture.view?.tag)!)
            setNeedsDisplay() // 重绘视图
            
        default:
            return
        }
    }
}











