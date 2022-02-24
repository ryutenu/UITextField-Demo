//
//  ViewController.swift
//  UITextField-Demo
//
//  Created by Alan Liu on 2022/02/22.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    
    private var disposeBag = DisposeBag()
    
    private var addedHeight = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = UserDefaults.standard.string(forKey: "text")
        
        setupTextField()
        
        addKeyboardObserver()
    }
    
    private func setupTextField() {
        let gesture = UITapGestureRecognizer()
        view.addGestureRecognizer(gesture)
        
        // 入力欄以外タッチするとキーボードが閉じる
        gesture.rx.event.asDriver().drive(onNext: { _ in
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        // 入力するたびにこの処理が走る
        textField.rx.text.orEmpty.asDriver().drive(onNext: { [unowned self] text in
            if text.lengthOfBytes() > 8, text.count > 0 {
                textField.text = String(text.prefix(text.count-1))
            }
            label.text = text.isEmpty ? "label" : textField.text
        }).disposed(by: disposeBag)
        
        // キーボードが表示された時に処理が走る
        textField.rx.controlEvent(.editingDidBegin).asDriver().drive(onNext: { _ in
            print("editingDidBegin")
        }).disposed(by: disposeBag)
        
        // textFieldの値が変更されるたびに処理が走る
        textField.rx.controlEvent(.editingChanged).asDriver().drive(onNext: { _ in
            
        }).disposed(by: disposeBag)
        
        // キーボードのReturn Keyがタップされる時に処理が走る
        textField.rx.controlEvent(.editingDidEndOnExit).asDriver().drive(onNext: { _ in
            print("editingDidEndOnExit")
        }).disposed(by: disposeBag)
        
        // キーボードが閉じた時に処理が走る
        textField.rx.controlEvent(.editingDidEnd).asDriver().drive(onNext: { _ in
            print("editingDidEnd")
            UserDefaults.standard.set(self.textField.text, forKey: "text")
        }).disposed(by: disposeBag)
        
        // 不明
        textField.rx.controlEvent(.valueChanged).asDriver().drive(onNext: { _ in
            print("valueChanged")
        }).disposed(by: disposeBag)
    }
    
    private func addKeyboardObserver() {
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(showKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notification.addObserver(self, selector: #selector(hideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func showKeyboard(_ notification: Notification) {
        print("showKeyboard")
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let keyboardTopLine = view.frame.height - keyboardHeight
        
        let convertedFrame = textField.convert(textField.frame.origin, to: scrollView)
        let bottomLine = convertedFrame.y + textField.frame.height
        let displayBottom = bottomLine - scrollView.contentOffset.y
        
        if displayBottom > keyboardTopLine {
            let height = displayBottom - keyboardTopLine + 20
            addedHeight = height
            
            let offset = CGPoint(x: 0, y: scrollView.contentOffset.y + height)
            scrollView.setContentOffset(offset, animated: true)
            
            scrollViewBottomConstraint.constant = keyboardHeight
        }
    }
    
    @objc func hideKeyboard(_ notification: Notification) {
        print("hideKeyboard")
        
    }
}
