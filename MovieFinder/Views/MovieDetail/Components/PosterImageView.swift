//
//  PosterImageView.swift
//  MovieFinder
//
//  Created by Diana Amirzadyan on 10.09.25.
//

import SwiftUI

struct PosterImageView: View {
    let path: String?
    
    var body: some View {
        CachedAsyncImage(
            url: ImageURLs.poster(path),
            placeholder: {
                ZStack { Rectangle().fill(.quaternary); ProgressView() }
            },
            failure: {
                ZStack { Rectangle().fill(.quaternary); Image(systemName: "film").imageScale(.large) }
            },
            content: { image in
                image.resizable().scaledToFill()
            }
        )
        .aspectRatio(2/3, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .mask(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .background(Color(.secondarySystemBackground))
        
        //        AsyncImage(
        //            url: ImageURLs.poster(path),
        //            transaction: Transaction(animation: .none)
        //        ) { phase in
        //            switch phase {
        //            case .empty:
        //                ZStack {
        //                    Rectangle().fill(.quaternary)
        //                    ProgressView()
        //                }
        //
        //            case .success(let image):
        //                image
        //                    .resizable()
        //                    .scaledToFill()
        //
        //            case .failure:
        //                ZStack {
        //                    Rectangle().fill(.quaternary)
        //                    Image(systemName: "film").imageScale(.large)
        //                }
        //
        //            @unknown default:
        //                Rectangle().fill(.quaternary)
        //            }
        //        }
        //        .aspectRatio(2 / 3, contentMode: .fit)
        //        .frame(maxWidth: .infinity)
        //        .background(Color(.secondarySystemBackground))
        //        .mask(
        //            RoundedRectangle(
        //                cornerRadius: 12,
        //                style: .continuous
        //            )
        //        )
        //        .contentShape(Rectangle())
        //    }
    }
}
