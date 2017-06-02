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
    open var pointArray:[CGPoint]?{
        
        didSet{
            
            guard pointViewArray.count == 0 else {
                return
            }
            
            // 重绘
            setNeedsDisplay()
            // 添加小圆圈
            creatPoint()
            
            creatPointView()

        }
    }
    
    /// 描绘进度(0.0 ~ 1.0)
    var proportion:CGFloat = 0.0
    
    /// 描绘速率
    open var rate:CGFloat = 0.5
    
    /// 定时器
    var timer:Timer?
    
    /// 保存控制点
    var controlPoints:[CGPoint] = []
    
    /// 判断是否开始绘制贝塞尔曲线
    var isDrawBezier = false
    
    /// 判断是否重置数据线
    var isResetDataLine = false
    
    /// 判断是否停止画线
    var isStop = false
    
    /// 小圆圈数组，删除点的时候使用
    var dotArray:[UIView] = []
    
    /// 颜色数组
    let colorArray:[CGColor] = [UIColor.blue.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor,UIColor.blue.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor,UIColor.blue.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor,UIColor.blue.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.orange.cgColor, UIColor.green.cgColor]
    
    fileprivate var pointViewArray:[UIView] = []
    
    override func draw(_ rect: CGRect) {
        
        guard pointArray != nil else {
            return
        }
        
        // 绘制初始曲线
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addLines(between: pointArray!)
        ctx?.strokePath()
        
        if isDrawBezier {
            drawLines(ctx: ctx!)
        }
        
        // 画完曲线后由于颜色不对需要重绘
        if isResetDataLine {
            
            isResetDataLine = false
            ctx?.addLines(between: controlPoints) // 重绘曲线
            ctx?.setStrokeColor(UIColor.red.cgColor)
            ctx?.strokePath()
            
            controlPoints.removeAll() // 清空控制点
        }
        
    }

    
    // MARK: - 批量画线
    fileprivate func drawLines(ctx:CGContext) {
        
        if pointArray?.count == 1 {
            return
        }
        
        var pointArr:[CGPoint] = pointArray!
        
        repeat {
            pointArr = calculateCoordinates(pointArray: pointArr)
            ctx.addLines(between: pointArr)
            ctx.setStrokeColor(colorArray[pointArr.count])
            ctx.strokePath()
            
        } while pointArr.count != 1
        
        controlPoints.append(pointArr.first!)
        
        ctx.addLines(between: controlPoints)
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.strokePath()
    }
    
}

// MARK: - 计算控制点
extension BezierView {
    
    // MARK: - 计算新的数据点
    fileprivate func calculateCoordinates(pointArray:[CGPoint]) -> [CGPoint] {
        
        var newPointArray:[CGPoint] = []
        
        for i in 0..<(pointArray.count - 1) {
        
           let newPoint = calculateBetweenPoint(pointOne: pointArray[i], pointTwo: pointArray[i+1])
            
           newPointArray.append(newPoint)
        }
        
        return newPointArray
    }
    
    // MARK: 计算一阶贝塞尔曲线(向量方向为：pointOne -> pointTwo)
    fileprivate func calculateBetweenPoint(pointOne:CGPoint, pointTwo:CGPoint) -> CGPoint{
    
        let x = pointOne.x * (1 - proportion) + pointTwo.x * proportion
        
        let y = pointOne.y * (1 - proportion) + pointTwo.y * proportion
        
        return CGPoint(x:x, y:y)
    }
    
    // MARK: - 添加数据点
    open func addPoint(point:CGPoint){
    
        pointArray?.append(point)
        
        for subview in subviews {
            subview.removeFromSuperview()
        }
        
        setNeedsDisplay()
        // 添加小圆圈
        creatPoint()
        
        creatPointView()
    }
    
    // MARK: - 删除数据点
    open func delPoint(){
    
        if pointArray?.count == 0 {
            return
        }
        
        pointViewArray.last?.removeFromSuperview()
        dotArray.last?.removeFromSuperview()
        pointArray?.removeLast()
        pointViewArray.removeLast()
        dotArray.removeLast()
        setNeedsDisplay()
    }
}

// MARK: - 计时相关
extension BezierView {
    
    /// 开启定时器
    open func startTimer() {
        
        if isStop == false {
            proportion = 0.0
            isDrawBezier = true
        }
        
        timer = Timer(timeInterval: 0.001, target: self, selector:#selector(reduced) , userInfo: nil, repeats: true)
        
        RunLoop.current.add(timer!, forMode:RunLoopMode.commonModes)
    }
    
    /// 停止画线
    open func stopDrawBezier(){
        isStop = true
        timer?.invalidate()
    }
    
    /// 移除定时器
    fileprivate func removeTimer() {
        
        isDrawBezier = false
        isStop = false
        isResetDataLine = true
        setNeedsDisplay()
        timer?.invalidate()
    }
    
    
    @objc fileprivate func reduced() {
        
        guard Int(proportion) != 1 else {
            removeTimer()
            return
        }
        proportion = proportion + 0.01 - (1 - rate) * 0.01
        setNeedsDisplay()
    }
}

// MARK: - 小圆圈相关
extension BezierView {
    
    // MARK: - 创建小圆圈
    fileprivate func creatPoint(){
        
        for i in 0..<(pointArray?.count)! {
            
            let center = (pointArray?[i])!
            
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
            dotArray.append(dot)
            
            // 添加手势
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(movePoint(gesture:)))
            longPressGesture.minimumPressDuration = 0.1
            dot.addGestureRecognizer(longPressGesture)
        }
    }
    
    // MARK: - 监听手势改变小圆圈坐标
    @objc fileprivate func movePoint(gesture:UIGestureRecognizer) {
        
        guard isDrawBezier == false else {
            return
        }
        
        switch gesture.state {
            
        case .changed:
            // 改变center
            gesture.view?.center = gesture.location(in: self)
            pointArray?.remove(at: (gesture.view?.tag)!)
            pointArray?.insert(gesture.location(in: self), at:(gesture.view?.tag)!)
            refreshPointView() // 刷新坐标
            setNeedsDisplay()  // 重绘视图
            
        default:
            return
        }
    }
    
    // MARK: - 刷新坐标视图
    fileprivate func refreshPointView(){
        
        for i in 0..<(pointArray?.count)! {
            
            let point = (pointArray?[i])!
            
            let pointLB = pointViewArray[i] as! UILabel
            
            pointLB.text = "P" + String(i) + "(\(point.x),\(point.y))"
            pointLB.font = UIFont.systemFont(ofSize: 13.0)
        }
    }
    
    // MARK: - 创建坐标视图
    fileprivate func creatPointView(){
    
        let height = 30
        
        pointViewArray.removeAll()
        
        for i in 0..<(pointArray?.count)! {
            
            let point = (pointArray?[i])!
    
            // 添加圆圈标记
            let pointLB = UILabel(frame: CGRect(x: 10, y: Int(ScreenHeight - CGFloat(110 + i*height)), width: 120, height: height))
            pointLB.text = "P" + String(i) + "(\(point.x),\(point.y))"
            pointLB.font = UIFont.systemFont(ofSize: 13.0)

            pointViewArray.append(pointLB)
            
            addSubview(pointLB)
        }
        
    }
}











