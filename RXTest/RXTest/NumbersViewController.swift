//
//  NumbersViewController.swift
//  RxExample
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import UIKit
import Alamofire
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

    var disposeBag = DisposeBag()

class NumbersViewController: UIViewController {

    @IBOutlet var number1: UITextField!
    @IBOutlet var number2: UITextField!
    @IBOutlet var number3: UITextField!
    @IBOutlet var result: UILabel!
    var count = Variable(0)//可监听的数据结构
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a = [1:1]
        print(type(of:a.keys.first))
//                
//        Observable.combineLatest(number1.rx.text.orEmpty,number2.rx.text.orEmpty,number3.rx.text.orEmpty){ textValue1 , textValue2, textValue3 -> Int in
//                return ((Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0))
//            }
//            .map{$0.description}
//            .bindTo(result.rx.text)
//            .disposed(by: disposeBag)
//        func myInterval(_ interval: TimeInterval) -> Observable<Int> {
//            return Observable.create { observer in
//                print("Subscribed")
//                let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
//                timer.scheduleRepeating(deadline: DispatchTime.now() + interval, interval: interval)
//                
//                let cancel = Disposables.create {
//                    print("Disposed")
//                    timer.cancel()
//                }
//                
//                var next = 0
//                timer.setEventHandler {
//                    if cancel.isDisposed {
//                        return
//                    }
//                    observer.on(.next(next))
//                    next += 1
//                }
//                timer.resume()//重新开始
//                return cancel
//            }
//        }
//
//        
//        let counter = myInterval(0.1)
//            .shareReplay(1)
//        
//        print("Started ----")
//        
//        let subscription1 = counter
//            .subscribe(onNext: { n in
//                print("First \(n)")
//            })
//        let subscription2 = counter
//            .subscribe(onNext: { n in
//                print("Second \(n)")
//            })
//        let subscription3 = counter
//            .subscribe(onNext: { n in
//                print("Thired \(n)")
//            })
//        
//        Thread.sleep(forTimeInterval: 0.5)
//        
//        subscription1.dispose()
//        
//        
//        Thread.sleep(forTimeInterval: 0.5)
//
//        
//        subscription2.dispose()
//        
//        Thread.sleep(forTimeInterval: 0.5)
//        
//        
//        subscription3.dispose()
//        
//        print("Ended ----")
     
//        let sequenceOfInts = PublishSubject<Int>()
//        let a = sequenceOfInts.map{ i -> Int in
//            print("MAP---\(i)")
//            return i
//            }.shareReplay(1)
//         a.subscribe() {
//            print("--1--\($0)")
//        }
//        sequenceOfInts.on(.next(1))
//        sequenceOfInts.on(.next(2))
//        a.subscribe {
//            print("--2--\($0)")
//        }
//        sequenceOfInts.on(.next(3))
//        sequenceOfInts.on(.next(4))
//        a.subscribe {
//            print("--3--\($0)")
//        }
////        sequenceOfInts.onCompleted()
//        _ = myInterval(0.1)
//            .myMap { e in
//                return "This is simply \(e)"
//            }
//            .subscribe(onNext: { n in
//                print(n)
//            })
//        var timer:Timer?
//
//        
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(updateValue) , userInfo: nil, repeats: true)
//
//        _ = count.asObservable().subscribe(onNext: { (num) in
//            self.result.text = "\(num)"
//        })
        
//        number1.rx.isSelected
//        
//        let sequenceOfInts = PublishSubject<Int>()
//        let a = sequenceOfInts.map{ i -> Int in
//            print("MAP---\(i)")
//            return i * 2
//        }
//        .shareReplay(1)//重播
//        _ = a.subscribe(onNext: { (s) in
//            print("--1----\(s)")
//        })
//        
//        sequenceOfInts.on(.next(1))
//        sequenceOfInts.on(.next(2))
//
//        _ = a.subscribe(onNext: { (s) in
//            print("--2----\(s)")
//        })
//        sequenceOfInts.on(.next(3))
//        sequenceOfInts.on(.next(4))
//        _ = a.subscribe(onNext: { (s) in
//            print("--3----\(s)")
//        })
//        
//        sequenceOfInts.on(.completed)
        
        
        
        
}

    func updateValue(){
        count.value = count.value + 1
    }
    
//extension ObservableType {
//    func myMap<R>(transform: @escaping (E) -> R) -> Observable<R> {
//        return Observable.create { observer in
//            let subscription = self.subscribe { e in
//                switch e {
//                case .next(let value):
//                    let result = transform(value)
//                    observer.on(.next(result))
//                case .error(let error):
//                    observer.on(.error(error))
//                case .completed:
//                    observer.on(.completed)
//                }
//            }
//            
//            return subscription
//        }
//    }
//}



}
