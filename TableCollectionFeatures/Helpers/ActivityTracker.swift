//
//  ActivityTracker.swift
//  TableCollectionFeatures
//
//  Created by Alexander Khiger on 28.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class ActivityTracker: SharedSequenceConvertibleType {
    
    typealias Element = Bool
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _lock = NSRecursiveLock()
    private let _variable = BehaviorRelay<Bool>(value: false)
    private let _loading: SharedSequence<SharingStrategy, Bool>
    
    init() {
        _loading = _variable.asDriver()
            .distinctUntilChanged()
    }
    
    func reset() {
        _lock.lock()
        _variable.accept(true)
        _lock.unlock()
    }
    
    func stop() {
        _lock.lock()
        _variable.accept(false)
        _lock.unlock()
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        _loading
    }
    
    private func subscribed() {
        _lock.lock()
        _variable.accept(true)
        _lock.unlock()
    }
    
    private func sendStopLoading() {
        _lock.lock()
        _variable.accept(false)
        _lock.unlock()
    }
    
    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        source.asObservable()
            .do(
                onNext: { _ in
                    self.sendStopLoading()
                },
                onError: { _ in
                    self.sendStopLoading()
                },
                onCompleted: {
                    self.sendStopLoading()
                },
                onSubscribe: subscribed
            )
    }
    
}

extension ObservableConvertibleType {
    
    func trackActivity(_ activityTracker: ActivityTracker) -> Observable<Element> {
        activityTracker.trackActivityOfObservable(self)
    }
    
}

extension Driver {
    
    func trackActivity(_ activityTracker: ActivityTracker) -> Driver<Element> {
        activityTracker.trackActivityOfObservable(self).asDriverOnErrorJustComplete()
    }
    
}
