//
//  FriendViewModel.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 11/05/2023.
//

import Foundation
import RxSwift

class FriendViewModel {
    var models = BehaviorSubject(value: [UserFriendModel]())
    var filterModels = BehaviorSubject(value: [UserFriendModel]())
    
    func readJSONFile(fileName: String) {
        do {
          if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"),
          let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
              let decoder = JSONDecoder()
              let data = try decoder.decode(FriendModel.self, from: jsonData)
              self.models.on(.next(data.data))
              self.filterModels.onNext(data.data)
          }
        } catch {
          print(error)
        }
    }
    
    func getSearchResults(searchText: String) {
        var filter: [UserFriendModel] = []
        guard let models = try? models.value() else {return}
        if searchText.isEmpty {
            filterModels.onNext(models)
        }
        else {
            for model in models {
                if model.displayName.lowercased().folded.contains(searchText.lowercased().folded) {
                    filter.append(model)
                }
            }
            filterModels.onNext(filter)
        }
    }
    
    func deleteModel(model: UserFriendModel) {
        guard var models = try? models.value() else {return}
        guard var filterModels = try? filterModels.value() else {return}
        var index = 0
        for i in 0..<models.count {
            if models[i].id == model.id {
                index = i
            }
        }
        models.remove(at: index)
        self.models.onNext(models)
        for i in 0..<filterModels.count {
            if filterModels[i].id == model.id {
                index = i
            }
        }
        filterModels.remove(at: index)
        self.filterModels.onNext(filterModels)
    }
    
    func addModel(model: UserFriendModel) {
        guard var models = try? models.value() else {return}
        models.insert(model, at: 0)
        self.models.onNext(models)
        guard var filterModels = try? filterModels.value() else {return}
        filterModels.insert(model, at: 0)
        self.filterModels.onNext(filterModels)
    }
}
