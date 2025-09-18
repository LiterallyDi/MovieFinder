//
//  README.md
//  MovieFinder
//
//  Created by Diana Amirzadyan on 10.09.25.
//

# 🎬 MovieFinder

iOS 17 • SwiftUI + Combine • MVVM • TMDB API

## 🚀 Setup

1. Xcode 15+ / iOS 17+
2. Get a **TMDB API Read Access Token (v4)** from your [TMDB account](https://www.themoviedb.org/settings/api).
3. Add it to **Info.plist**:
   - **Key**: `e58f78a7809977806996e95975209084`
   - **Type**: String
   - **Value**: `eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNThmNzhhNzgwOTk3NzgwNjk5NmU5NTk3NTIwOTA4NCIsIm5iZiI6MTc1NzI1OTQ1My41NTIsInN1YiI6IjY4YmRhNmJkMDI1MWZlZmZjZTk0NzRhOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qanbMu8WfyLjsTJo6ForFoS4URvA2ctNRBRIxFB8soI`
4. Run the project in Xcode: `⌘R`.

> Images are loaded from: `https://image.tmdb.org/t/p/w500`.

---

## ✨ Features

- Popular movies list (grid + infinite scroll / pagination)
- Search movies by title (with 400ms debounce)
- Movie detail screen (poster, rating, release date, overview)
- Async image loading with placeholder and cache
- Local cache for popular movies (page=1) in UserDefaults
- Error handling with retry button
- Haptics using SwiftUI `.sensoryFeedback` when new movies load
- Responsive grid: 2 columns on compact width, 3 on wider screens

---

## 🧱 Architecture
 Views (SwiftUI)
 └─ ViewModels
 └─ MovieRepository (protocol)
 ├─ TMDBMovieRepository (network)
 │ └─ NetworkService (URLSession)
 └─ MovieCache (UserDefaults)

**MVVM + Repository + Combine + UserDefaults Cache**


- **View ↔ ViewModel**: state with `@Published`, triggers via Combine pipelines.
- **Repository**: abstracts data sources (network + cache).
- **NetworkService**: shared HTTP client with `Authorization: Bearer <token>`.
- **Cache**: `UserDefaultsMovieCache` for popular page=1 (instant load).
- **Images**: `CachedAsyncImage` using `URLCache.shared` with `returnCacheDataElseLoad`.

 ---

## 📁 Project Structure
 MovieApp/
 ├── Models/ (Movie, MovieResponse, APIError, ...)
 MovieDetailViewModel)
 ├── Views/
 │ ├── ContentView, MovieListView, MovieDetailView
 CachedAsyncImage)
 ├── Services/
 │ ├── NetworkService / APIClient
 TMDBMovieRepository
 │ └── Cache/ (MovieCache, UserDefaultsMovieCache)
 └── Utils/ (Constants, Layout, ImageURLs, ...)


---

## 🔌 TMDB API

- **Popular**: `GET /3/movie/popular?page=1..N`
- **Search**: `GET /3/search/movie?query=...&page=1..N`
- **Details**: `GET /3/movie/{id}`
- **Images**: `https://image.tmdb.org/t/p/w500{poster_path}`

Headers:
Authorization: Bearer <eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNThmNzhhNzgwOTk3NzgwNjk5NmU5NTk3NTIwOTA4NCIsIm5iZiI6MTc1NzI1OTQ1My41NTIsInN1YiI6IjY4YmRhNmJkMDI1MWZlZmZjZTk0NzRhOSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.qanbMu8WfyLjsTJo6ForFoS4URvA2ctNRBRIxFB8soI>
Accept: application/json


---

## 🧪 Testing (optional)

- 

---

## 🛠 Debugging & Offline Mode

- **Offline simulation**: iOS Simulator → Features → *Network Link Conditioner*.
- **Clear cache**: use `DebugClearCacheButton` (Debug only).
- **Clear image cache**:
  ```swift
  URLCache.shared.removeAllCachedResponses()
