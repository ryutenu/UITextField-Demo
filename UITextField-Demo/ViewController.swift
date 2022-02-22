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
        
        gesture.rx.event.asDriver().drive(onNext: { _ in
            /// 入力欄以外タッチするとキーボードが閉じる
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        textField.rx.text.orEmpty.asDriver().drive(onNext: { [unowned self] text in
            // 入力するたびにこの処理が走る
            label.text = text.isEmpty ? "label" : text
        }).disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidBegin).asDriver().drive(onNext: { _ in
            // キーボードが表示された時に処理が走る
            print("editingDidBegin")
        }).disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingChanged).asDriver().drive(onNext: { _ in
            // textFieldの値が変更されるたびに処理が走る
        }).disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEnd).asDriver().drive(onNext: { _ in
            // キーボードが閉じた時に処理が走る
            print("editingDidEnd")
            // 入力した内容を保存する
            UserDefaults.standard.set(self.textField.text, forKey: "text")
        }).disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidEndOnExit).asDriver().drive(onNext: { _ in
            // キーボードのReturn Keyがタッチされる時に処理が走る
            print("editingDidEndOnExit")
        }).disposed(by: disposeBag)
        
        textField.rx.controlEvent(.valueChanged).asDriver().drive(onNext: { _ in
            // 不明
            print("valueChanged")
        }).disposed(by: disposeBag)
    }
}
