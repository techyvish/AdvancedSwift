//: Please build the scheme 'RxSwiftPlayground' first

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import RxSwift

var disposeBag = DisposeBag()

let o = Observable<Int>.create { (observer) -> Disposable in
    DispatchQueue.global(qos:.default).async {
        Thread.sleep(forTimeInterval: 3)
        observer.onNext(5)
        observer.onCompleted()
    }
    
    return Disposables.create {
        print("Disposed")
    }
}

o.subscribe(onNext:{ (data) in
    print(data)
}).addDisposableTo(disposeBag)

let subject = PublishSubject<String>()
let observable: Observable<String> = subject

subject.onNext("Ignored ...")

observable.subscribe(onNext: { (data) in
    print (data)
}).addDisposableTo(disposeBag)


subject.onNext("TEST2")


// Replay Subject
// You use it when you’re interested in all values of the subjects lifetime.

let replaySubject = ReplaySubject<String>.create(bufferSize: 3)
replaySubject.onNext("1")
replaySubject.onNext("2")
replaySubject.onNext("3")

let replayObserver: Observable<String> = replaySubject

replayObserver.subscribe( onNext: { (data) in
    print(data)
}).addDisposableTo(disposeBag)


replaySubject.onNext("4")
replaySubject.onNext("8")

// Behaviour Subject
// You use it when you just need to know the last value, for example the array of elements for your table view.

let behviourSubject = BehaviorSubject<String>(value: "Initial Value")
behviourSubject.onNext("Will not print")
behviourSubject.onNext("Will not print")
behviourSubject.onNext("Will be printed")

let behviourSubjectObservable : Observable<String> = behviourSubject

behviourSubjectObservable.subscribe(onNext: { (data) in
    print(data)
}).addDisposableTo(disposeBag)


