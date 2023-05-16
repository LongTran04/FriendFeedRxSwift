//
//  InvitationViewModel.swift
//  FriendFeedRxSwift
//
//  Created by Long Tran on 11/05/2023.
//

import Foundation
import RxSwift

class InvitationViewModel {
    var models = BehaviorSubject(value: [UserInvitationModel]())
    var filterModels = BehaviorSubject(value: [UserInvitationModel]())
    
    func readJSONFile(fileName: String) {
        do {
          if let bundlePath = Bundle.main.path(forResource: fileName, ofType: "json"),
          let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
              let decoder = JSONDecoder()
              let data = try decoder.decode(InvitationModel.self, from: jsonData)
              self.models.onNext(data.data)
              self.filterModels.onNext(data.data)
          }
        } catch {
          print(error)
        }
    }
    
    func getSearchResults(searchText: String) {
        var filter: [UserInvitationModel] = []
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
    
    func deleteModel(model: UserInvitationModel) {
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
    
    func convertInvitaionToFriendModel(model: UserInvitationModel) -> UserFriendModel {
        let current = Current(city: 0, privacy: 0)
        let address = Addresss(current: current)
        let work = FriendWork(userID: model.id, workspaceID: "", company: model.work[0].company, departments: [], departmentIDS: [], departmentID: "", department: model.work[0].department, title: model.work[0].title, roleID: "", listDepartments: [])
        let works = [work]
        let info = Info(bio: "", addresss: address, work: works)
        let friendModel = UserFriendModel(id: model.id, avatar: model.avatar, avatarThumbPattern: model.avatarThumbPattern, displayName: model.displayName, statusVerify: model.statusVerify, statusKyc: model.statusVerify, info: info, relation: 0, countMutualFriend: model.countMutualFriend, howFound: 0, createdAt: 0)
        return friendModel
    }

}
