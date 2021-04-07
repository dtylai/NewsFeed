//
//  ViewController.swift
//  NewsFeedApp
//
//  Created by Tulai Dima on 31.03.21.
//

import UIKit
import PaginationUIManager

public func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
class NewsViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    fileprivate var paginationUIManager: PaginationUIManager?
    fileprivate var dataSource: [NewsViewModel] = []
    fileprivate var fetchedArticles: [NewsViewModel] = []
//    fileprivate var reloadedArticles: [NewsViewModel] = []
    fileprivate var pageNumber = 1
    fileprivate var pagaSizee = 5
    fileprivate var componentsFromCuurentDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
    let dataLoader = DataLoader()
    fileprivate var dateTo = Date()
    fileprivate var dateFrom = Date()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Constants.cellNibName,
                                 bundle: Bundle.main),
                           forCellReuseIdentifier: Constants.cellReuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .darkGray
        setupPagination()
        fetchItems()
        change()
        fetchData()
//        reloadedArticles = dataSource
    }
    
    fileprivate func setupPagination() {
        paginationUIManager = PaginationUIManager(scrollView: self.tableView, pullToRefreshType: .custom(RefreshView.newInstance))
        paginationUIManager?.delegate = self
    }
    
    fileprivate func fetchItems() {
        paginationUIManager?.load {
        }
    }

//    fileprivate func handleDataLoad(items: [NewsViewModel]) {
//        self.dataSource.removeAll()
//        self.fetchedArticles.removeAll()
//        self.dataSource = items
//        self.tableView.reloadData()
//    }
//
//    fileprivate func handleMoreDataLoad(items: [NewsViewModel]) {
//        self.items.append(contentsOf: items)
//        self.tableView.reloadData()
//    }
    
    func change(){
        componentsFromCuurentDate.hour = 0
        componentsFromCuurentDate.minute = 0
        dateFrom = Calendar.current.date(from: componentsFromCuurentDate)!
        pageNumber = 1
        dateTo = Date()
        
    }
    func fetchData(){
        
        dataLoader.request(.everything( pageSize: pagaSizee, timeFrom: dateFrom, timeTo: dateTo)) { [weak self](response, _) in
            guard let self = self,
                let articles = response?.articles else {
                    return
            }
            var viewModels = [NewsViewModel]()
            for article in articles {
                let viewModel = NewsViewModel(model: article)
                viewModels.append(viewModel)
            }
            self.fetchedArticles.append(contentsOf: viewModels)
            self.dataSource = self.fetchedArticles
        
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    

}



extension NewsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: Constants.cellReuseID)
            as? NewsTableViewCell else {
            return UITableViewCell()
        }
        if dataSource.count > 0 {
         cell.setup(with: dataSource[indexPath.row])
        return cell
        }
        else{
            return cell
        }
        
    }
    
}



extension NewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else { return }
        cell.cellSelected()
    }
}

extension NewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
            !text.isEmpty else { return }
        self.dataSource = []
            for article in fetchedArticles {
                if (article.description.lowercased().contains(text.lowercased())){
                    dataSource.append(article)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        dataSource = fetchedArticles
        tableView.reloadData()
    }
}
//MARK: Pagination Manager

extension NewsViewController    : PaginationUIManagerDelegate {
    func refreshAll(completion: @escaping (Bool) -> Void) {
        delay(3) {
            self.dataSource = []
            self.fetchedArticles = []
//            self.dataSource = self.reloadedArticles
            self.change()
            self.fetchData()

            completion(true)
        }
    }
    
    func loadMore(completion: @escaping (Bool) -> Void) {
        delay(2) {
            self.pageNumber += 1
            self.dateFrom -= (60*60*24)
            self.dateTo = self.dateFrom + (60*60*24)
            self.fetchData()
            let shouldLoadMore = self.dataSource.count < (self.pagaSizee * 7)
            completion(shouldLoadMore)
        }
    }
}

