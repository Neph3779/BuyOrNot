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
    private var naverResults: NaverBlogResult?
    private var tistoryResults: KakaoBlogResult?
    private var joinedReview = [ReviewContent]()

    private var didYoutubeFetchingDone = false
    private var didNaverFetchingDone = false
    private var didTistoryFetchingDone = false

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
        YoutubeCrawler.shared.fetchYoutubeReviews(query: "\(product.brand) \(product.name) 리뷰",
                                                  completion: youtubeVideoIdFetchCompletion(contents:))

    }

    private func youtubeVideoIdFetchCompletion(contents: [YoutubeCrawlingResult.VideoContent]?) {
        var videoIds = [String?]()
        guard let contents = contents else { return }
        contents.forEach { videoIds.append($0.videoRenderer?.videoId) }
        let videoIdsWithoutNil = videoIds.compactMap { $0 }

        for index in 0 ..< videoIdsWithoutNil.count {
            YoutubeAPIClient.shared.fetchYoutubeVideoById(videoId: videoIdsWithoutNil[index]) { [weak self]
                (response: DataResponse<YoutubeVideosResult, AFError>) in
                guard let self = self else { return }
                do {
                    let result = try JSONDecoder().decode(YoutubeVideosResult.self, from: response.data!)
                    self.youtubeResults.append(result)
                } catch {

                }
                if index == videoIdsWithoutNil.count - 1 {
                    self.didYoutubeFetchingDone = true
                    if self.didFetchingDone {
                        self.joinReviews()
                        self.reviewFetcherDelegate?.reloadData()
                    }
                }
            }
        }
    }

    private func fetchNaverBlogReviews() {
        NaverSearchAPIClient.shared
            .fetchNaverBlogResults(query: "\(product.brand) \(product.name) 리뷰", count: 20) { [weak self]
                (response: DataResponse<NaverBlogResult, AFError>) in
                guard let self = self else { return }
                do {
                    self.naverResults = try JSONDecoder().decode(NaverBlogResult.self, from: response.data!)
                } catch {

                }
                self.didNaverFetchingDone = true
                if self.didFetchingDone {
                    self.joinReviews()
                    self.reviewFetcherDelegate?.reloadData()
                }
            }
    }

    private func fetchTistoryBlogReviews() {
        KakaoAPIClient.shared
            .fetchKakaoBlogPosts(query: "\(product.brand) \(product.name) 리뷰", count: 20) { [weak self]
                (response: DataResponse<KakaoBlogResult, AFError>) in
                guard let self = self else {
                    return
                }
                do {
                    self.tistoryResults = try JSONDecoder().decode(KakaoBlogResult.self, from: response.data!)
                } catch {

                }
                self.didTistoryFetchingDone = true
                if self.didFetchingDone {
                    self.joinReviews()
                    self.reviewFetcherDelegate?.reloadData()
                }
            }
    }

    private func joinReviews() {
        let youtubeReviews: [ReviewContent]? = youtubeResults.map { result in
            let item = result.items[0]
            let thumbnailURL = URL(string: item.snippet.thumbnails.high.url)
            let link = URL(string: "https://www.youtube.com/watch?v=" + item.id)

            return ReviewContent(siteKind: .youtube, title: item.snippet.title,
                                 producerName: item.snippet.channelTitle,
                                 thumbnail: thumbnailURL, link: link, youtubeId: item.id)
        }

        let tistoryReviews: [ReviewContent]? = tistoryResults?.documents.map { item -> ReviewContent in
            let siteKind: ReviewSiteKind = item.link.contains("naver") ? .naver : .tistory
            let thumbnailURL = URL(string: item.thumbnail)
            let link = URL(string: item.link)
            return ReviewContent(siteKind: siteKind, title: item.title,
                                 producerName: item.blogName,
                                 thumbnail: thumbnailURL, link: link, youtubeId: nil)
        }

        let naverReviews: [ReviewContent]? = naverResults?.items.map { item -> ReviewContent? in
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

        while count < youtubeReviews?.count ?? 0 || count < naverReviews?.count ?? 0 || count < tistoryReviews?.count ?? 0 {
            if count < youtubeReviews?.count ?? 0 {
                joinedReview.append(youtubeReviews![count])
            }

            if count < tistoryReviews?.count ?? 0 {
                joinedReview.append(tistoryReviews![count])
            }

            if count < naverReviews?.count ?? 0 {
                joinedReview.append(naverReviews![count])
            }

            count += 1
        }

        reviewFetcherDelegate?.setJoinedReview(reviewContents: joinedReview)
    }
}
