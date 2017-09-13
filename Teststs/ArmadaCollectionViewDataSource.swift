//
//  ArmadaCollectionViewDataSource.swift
//  Armada
//
//  Created by Ola Roos on 2017-09-05.
//  Copyright © 2017 Ola Roos. All rights reserved.
//
//  NOTE:
//  This is a minimalistic custom datasource class which will enable us to get
//  data from the ArmadaAPI and display it in a collectionViewController.
//  T is any of the structures defined in ArmadaApi.swift.
//  Override this class when you want to implement it.  


import UIKit

class ArmadaCollectionViewDataSource<T>: NSObject, UICollectionViewDataSource {
    
    weak var collectionViewController: UICollectionViewController?
    var values = [[T]]()
    // NOTE:
    // This function lets us get the element and give it an indexpath to use 
    // in the collectionViewController when feeding it to the cell function
    // YOU NEED TO CHANGE THIS DESCRIPTION!
    subscript(indexPath: IndexPath) -> T {
        return values[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
//        return values[0][(indexPath as NSIndexPath).row]
    }
    
    init(collectionViewController: UICollectionViewController) {
        super.init()
        self.collectionViewController = collectionViewController
    }
    
    func refresh(_ refreshControl: UIRefreshControl? = nil) {
        print("calling refresh in ArmadaCollectionViewDatasource")
        updateFunc { response in
            switch response {
            case .success(let values):
                self.values = values
                print("we got values when refresh in ArmadaCollectionViewDataSource")
            case .error(let error):
                print("no values when refresh in ArmadaCollectionViewDataSource")
                if !self.values.isEmpty {
                    let alertController = UIAlertController(title: nil, message: (error as NSError).localizedDescription, preferredStyle: .alert)
                    self.collectionViewController?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    var isEmpty: Bool {
        return values.isEmpty
    }
    
    func updateFunc(_ callback: @escaping (Response<[[T]]>) -> Void) {}
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return values.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = UICollectionReusableView()
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {    

        return values[0].count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assert(false)
        return collectionView.dequeueReusableCell(withReuseIdentifier: "", for: indexPath)
        
    }

}
