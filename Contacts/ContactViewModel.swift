//
//  ContactViewModel.swift
//  Contacts
//
//  Copyright © 2017 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 7/25/17.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ContactViewModel {
    
    // MARK: - MVVM
    
    private let model: Contact
    
    // MARK: - RxSwift
    
    private let disposeBag = DisposeBag()
    
    var firstName: BehaviorSubject<String>
    var lastName: BehaviorSubject<String>
    var avatarURL: BehaviorSubject<String>
    
    let handleError: ((_ error: Error) -> Void) = {
        print($0)
    }
    
    // MARK: - Initialization
    
    init(model: Contact) {
        self.model = model
        
        firstName = BehaviorSubject<String>(value: model.firstName)
        firstName.subscribe(onNext: {
            model.firstName = $0
        }, onError: handleError, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        
        lastName = BehaviorSubject<String>(value: model.lastName)
        lastName.subscribe(onNext: {
            model.lastName = $0
        }, onError: handleError, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
        
        avatarURL = BehaviorSubject<String>(value: model.avatarURL)
        avatarURL.subscribe(onNext: {
            model.avatarURL = $0
        }, onError: handleError, onCompleted: nil, onDisposed: nil).addDisposableTo(disposeBag)
    }
}
