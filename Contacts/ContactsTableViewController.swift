//
//  ContactsViewController.swift
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

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ContactsTableViewController: UIViewController {
    
    var contacts: Variable<[ContactViewModel]> = {
        let path = Bundle.main.path(forResource: "MOCK_DATA", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        let json: [[String:Any]] = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String:Any]]
        let contacts = json.map { return Contact(fromJSON: $0) }.sorted { $0.firstName < $1.firstName }
        let viewModels = contacts.map { return ContactViewModel(model: $0) }
        return Variable(viewModels)
    }()
    
    var tableView = UITableView()
    
    private let cellId = "contactCellId"
    private let disposeBag = DisposeBag()
    private let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.fillSuperview()
        tableView.rowHeight = 44
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: cellId)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>()
        
        dataSource.configureCell = { (dataSource, tableView, indexPath, element) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? ContactTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = element
            return cell
        }
        dataSource.titleForHeaderInSection = { dataSource, section in
            return dataSource.sectionModels[section].header
        }
        
        let sections: [SectionOfCustomData] = alphabet.characters.map { (char) -> SectionOfCustomData in
            let contactsInSection = contacts.value.filter { try! $0.firstName.value().characters.first == char }
            let section = SectionOfCustomData(header: String(char), items: contactsInSection)
            return section
        }
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        tableView.rx
            .modelSelected(ContactViewModel.self)
            .subscribe(onNext:  { contactViewModel in
                let contactViewController = ContactViewController(viewModel: contactViewModel)
                self.navigationController?.pushViewController(contactViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

struct SectionOfCustomData {
    var header: String
    var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
    typealias Item = ContactViewModel
    
    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}
