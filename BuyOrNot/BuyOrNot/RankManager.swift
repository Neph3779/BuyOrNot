//
//  RankManager.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/11/23.
//

import Foundation

final class RankManager {
    static var rankedProducts: [RankedProduct] = [] // 랭킹 테이블 뷰에 뿌릴 data, static으로 관리 (database 적용 필요, 이후에 할 것)

    func refreshRank() {
        // 랭킹 자료 받고 가공해서 ranked Products에다가 넣어주는 작업
    }
    private init() {}
    static let shared = RankManager()
}
