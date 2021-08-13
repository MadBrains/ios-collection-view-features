//
//  Observable+Extensions.swift
//  TableCollectionFeatures
//
//  Created by Alexander Khiger on 28.06.2021.
//

import Foundation
import RxSwift
import RxCocoa

public protocol OptionalType {
    
    associatedtype Wrapped
    
    var optional: Wrapped? { get }
    
}

extension Optional: OptionalType {
    
    public var optional: Wrapped? { self }
    
}

extension ObservableType where Element == Bool {
    
    func not() -> Observable<Bool> {
        self.map(!)
    }
    
}

extension SharedSequenceConvertibleType {
    
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        map { _ in }
    }
    
}

extension SharedSequenceConvertibleType where Element == Bool {
    
    func not() -> SharedSequence<SharingStrategy, Bool> {
        self.map(!)
    }
    
    func isTrue() -> SharedSequence<SharingStrategy, Bool> {
        flatMap { isTrue in
            guard isTrue else {
                return SharedSequence<SharingStrategy, Bool>.empty()
            }
            return SharedSequence<SharingStrategy, Bool>.just(true)
        }
    }
    
    func filterFalse() -> SharedSequence<SharingStrategy, Bool> {
        filter { !$0 }
    }
    
}

extension SharedSequenceConvertibleType where Element: OptionalType {
    
    func ignoreNil() -> SharedSequence<SharingStrategy, Element.Wrapped> {
        flatMap { value in
            value.optional.map { .just($0) } ?? .empty()
        }
    }
    
}

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
        catchError { _ in .empty() }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { _ in .empty() }
    }
    
    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }
    
}

extension ObservableType where Element: OptionalType {
    
    func ignoreNil() -> Observable<Element.Wrapped> {
        flatMap { value in
            value.optional.map { Observable.just($0) } ?? Observable.empty()
        }
    }
    
}

extension ObservableType where Element: Collection {
    
    func ignoreEmpty() -> Observable<Element> {
        flatMap { array in
            array.isEmpty ? Observable.empty() : Observable.just(array)
        }
    }
    
}
