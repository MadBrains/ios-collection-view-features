//
//  ErrorTracker.swift
//  TableCollectionFeatures
//
//  Created by Alexander Khiger on 28.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

final class ErrorTracker: SharedSequenceConvertibleType {
    
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _subject = PublishSubject<Error>()
    
    deinit {
        _subject.onCompleted()
    }
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        source.asObservable().do(onError: onError)
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Error> {
        _subject.asObservable().asDriverOnErrorJustComplete()
    }
    
    func asObservable() -> Observable<Error> {
        _subject.asObservable()
    }
    
    func onError(_ error: Error) {
        _subject.onNext(error)
    }
    
}

extension ObservableConvertibleType {
    
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        errorTracker.trackError(from: self)
    }
    
}
