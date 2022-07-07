//
//  ReviewFetcher.swift
//  BuyOrNot
//
//  Created by 천수현 on 2021/12/02.
//

import Foundation
import Alamofire

protocol ReviewFetcherDelegate: AnyObject {
    func setJoinedReview(reviewContents: [ReviewContent])
    func reloadData()
}

final class ReviewFetcher {
    weak var reviewFetcherDelegate: ReviewFetcherDelegate?
    private var product: Product
    private var youtubeResults = [YoutubeVideosResult]()
    private var naverResult: NaverBlogResult?
    private var tistoryResult: KakaoBlogResult?
    private var joinedReview = [ReviewContent]()

    private var didYoutubeFetchingDone = false
    private var didNaverFetchingDone = false
    private var didTistoryFetchingDone = false

    private lazy var searchQuery = "\(product.brand) \(product.name) 리뷰"

    private var didFetchingDone: Bool {
        return didYoutubeFetchingDone && didNaverFetchingDone && didTistoryFetchingDone
    }

    init(product: Product, delegate: ReviewFetcherDelegate) {
        self.product = product
        self.reviewFetcherDelegate = delegate
    }

    func fetchReviews() {
        fetchYoutubeVideoIds()
        fetchNaverBlogReviews()
        fetchTistoryBlogReviews()
    }

    private func fetchYoutubeVideoIds() {
        YoutubeCrawler.shared.fetchYoutubeReviews(query: searchQuery,
                                                  completion: youtubeVideoIdFetchCompletion(videoIds:))

    }

    private func youtubeVideoIdFetchCompletion(videoIds: [String?]) {
        let videoIdsWithoutNil = videoIds.compactMap { $0 }

        videoIdsWithoutNil.enumerated().forEach { index, videoId in
            YoutubeAPIClient.shared.fetchYoutubeVideoById(videoId: videoId) { [weak self]
                (response: DataResponse<YoutubeVideosResult, AFError>) in
                guard let self = self,
                let responseData = response.data else { return }
                do {
                    let result = try JSONDecoder().decode(YoutubeVideosResult.self, from: responseData)
                    self.youtubeResults.append(result)
                } catch {

                }
                if index == videoIdsWithoutNil.count - 1 { // MARK: 유튜브 리뷰에 한해서 이 작업을 해주지 않으면 마지막에 엉뚱한 컨텐츠 담김
                    self.didYoutubeFetchingDone = true
                    self.checkAllFetchDone()
                }
            }
        }
    }

    private func fetchNaverBlogReviews() {
        NaverSearchAPIClient.shared
            .fetchNaverBlogResults(query: searchQuery, count: 20) { [weak self]
                (response: DataResponse<NaverBlogResult, AFError>) in
                guard let self = self else { return }
                do {
                    guard let data = response.data else {
                        self.didNaverFetchingDone = true
                        return
                    }
                    self.naverResult = try JSONDecoder().decode(NaverBlogResult.self, from: data)
                } catch {

                }
                self.didNaverFetchingDone = true
                self.checkAllFetchDone()
            }
    }

    private func fetchTistoryBlogReviews() {
        KakaoAPIClient.shared
            .fetchKakaoBlogPosts(query: searchQuery, count: 20) { [weak self]
                (response: DataResponse<KakaoBlogResult, AFError>) in
                guard let self = self else { return }
                do {
                    guard let data = response.data else {
                        self.didTistoryFetchingDone = true
                        return
                    }
                    self.tistoryResult = try JSONDecoder().decode(KakaoBlogResult.self, from: data)
                } catch {

                }
                self.didTistoryFetchingDone = true
                self.checkAllFetchDone()
            }
    }

    private func joinReviews() {
        let youtubeReviews: [ReviewContent] = youtubeResults.map { result -> ReviewContent? in
            if let item = result.items.first {
                let thumbnailURL = URL(string: item.snippet.thumbnails.high.url)
                let videoURL = YoutubeAPIClient.shared.individualVideoURL(itemId: item.id)

                return ReviewContent(siteKind: .youtube, title: item.snippet.title,
                                     producerName: item.snippet.channelTitle,
                                     thumbnail: thumbnailURL, link: videoURL, youtubeId: item.id)
            } else {
                return nil
            }
        }.compactMap { $0 }

        let tistoryReviews: [ReviewContent]? = tistoryResult?.documents.map { item -> ReviewContent in
            let siteKind: ReviewSiteKind = item.link.contains("naver") ? .naver : .tistory
            let thumbnailURL = URL(string: item.thumbnail)
            let link = URL(string: item.link)
            return ReviewContent(siteKind: siteKind, title: item.title,
                                 producerName: item.blogName,
                                 thumbnail: thumbnailURL, link: link, youtubeId: nil)
        }

        let naverReviews: [ReviewContent]? = naverResult?.items.map { item -> ReviewContent? in
            let link = URL(string: item.link)
            if let tistoryReviews = tistoryReviews {
                if tistoryReviews.filter({ $0.producerName == item.bloggerName }).isEmpty {
                    return ReviewContent(siteKind: .naver, title: item.title,
                                         producerName: item.bloggerName,
                                         thumbnail: nil, link: link, youtubeId: nil)
                }
            }
            return nil
        }.compactMap { $0 }

        var count = 0

        while count < youtubeReviews.count || count < naverReviews?.count ?? 0 || count < tistoryReviews?.count ?? 0 {
            if count < youtubeReviews.count {
                joinedReview.append(youtubeReviews[count])
            }

            if let tistoryReviews = tistoryReviews,
               count < tistoryReviews.count {
                joinedReview.append(tistoryReviews[count])
            }

            if let naverReviews = naverReviews,
               count < naverReviews.count {
                joinedReview.append(naverReviews[count])
            }

            count += 1
        }
    }

    private func checkAllFetchDone() {
        if didFetchingDone {
            joinReviews()
            reviewFetcherDelegate?.setJoinedReview(reviewContents: joinedReview)
            reviewFetcherDelegate?.reloadData()
        }
    }
}
