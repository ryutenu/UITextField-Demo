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
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textField: UITextField!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.text = UserDefaults.standard.string(forKey: "text")
        
        setupTextField()
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
            label.text = text.isEmpty ? "label" : text
        }).disposed(by: disposeBag)
        
        // キーボードが表示された時に処理が走る
        textField.rx.controlEvent(.editingDidBegin).asDriver().drive(onNext: { _ in
            print("editingDidBegin")
        }).disposed(by: disposeBag)
        
        // textFieldの値が変更されるたびに処理が走る
        textField.rx.controlEvent(.editingChanged).asDriver().drive(onNext: { _ in
//            print("editingChanged")
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
}
