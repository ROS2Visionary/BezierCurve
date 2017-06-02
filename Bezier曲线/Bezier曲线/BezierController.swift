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

class BezierController: UIViewController,UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationController?.navigationBar.backgroundColor = UIColor.lightGray
        title = "贝塞尔曲线"
        
        btnConstraintW.constant = (ScreenWith - 2 * 10 - 3 * 20) / 4
        
        bezierView.backgroundColor = UIColor.white
        view.addSubview(bezierView)
        bezierView.pointArray = pointArray
        view.sendSubview(toBack: bezierView)
        
        xTF.x = -130
        yTF.x = -130
        
        xTF.delegate = self
        yTF.delegate = self
        
        // 添加手势用于收回键盘
        let tap = UITapGestureRecognizer(target: self, action: #selector(clickView))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)
    }

    
    /// 贝塞尔view
    let bezierView = BezierView.init(frame:UIScreen.main.bounds)
    
    /// 初始数据点
    var pointArray:[CGPoint] = [CGPoint(x:58,y:270),CGPoint(x:120,y:80),CGPoint(x:300,y:150),CGPoint(x:240,y:300)]
    
    var isShowTF = true
    
    @objc func clickView(){
        if isShowTF {
            view.endEditing(true)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.xTF.x = -130
            }) { (_) in
                UIView.animate(withDuration: 0.3, animations: {
                    self.yTF.x = -130
                })
            }
            xTF.text = ""
            yTF.text = ""
            confirmBtn.isHidden = true
            isShowTF = !isShowTF
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text != "" {
            // X
            if textField.tag == 0 {
                let numValue = Float(textField.text! + string)
                if numValue! > Float(ScreenWith) {
                    return false
                }
            }
            
            // Y
            if textField.tag == 1 {
                let numValue = Float(textField.text! + string)
                if numValue! > Float(ScreenHeight) {
                    return false
                }
            }
        }
        
        return true
    }
    
    @IBOutlet weak var xTF: UITextField!
    
    @IBOutlet weak var yTF: UITextField!
    
    /// 确认按钮
    @IBOutlet weak var confirmBtn: UIButton!
    
    @IBOutlet weak var btnConstraintW: NSLayoutConstraint!
    
    
    // MARK: - 添加数据点
    @IBAction func addPoint(_ sender: Any) {
        
        let btn = sender as! UIButton
        btn.isUserInteractionEnabled = false
        
        if btn.titleLabel?.text == "Confirm" && (xTF.text != "" && yTF.text != "") {
            
            let xValue = Float(xTF.text!)!
            let yValue = Float(yTF.text!)!
            
            bezierView.addPoint(point: CGPoint(x:CGFloat(xValue),y:CGFloat(yValue)))
            
        }
        
        xTF.becomeFirstResponder()
        confirmBtn.isHidden = false
        isShowTF = true
        UIView.animate(withDuration: 0.3, animations: {
            self.xTF.x = 10
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.yTF.x = 10
            }){(_) in
                btn.isUserInteractionEnabled = true
            }
        }
        
    }
    
    // MARK: - 删除数据点
    @IBAction func delPoint(_ sender: Any) {
        
        bezierView.delPoint()
    }
    
    // MARK: - 开始描绘控制点
    @IBAction func start(_ sender: Any) {
        bezierView.startTimer()
    }
    
    // MARK: - 停止描绘控制点
    @IBAction func stop(_ sender: Any) {
        bezierView.stopDrawBezier()
    }
    
    // MARK: - 改变画线速度
    @IBAction func sliderChanged(_ sender: Any) {
        
        let slider = sender as! UISlider
        
        bezierView.rate = CGFloat(slider.value)
    }
    
}










