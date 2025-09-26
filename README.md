# DownloadDemo

一個使用 SwiftUI 開發的 iOS 檔案下載示範應用程式，展示如何實現檔案下載功能，包含進度顯示、錯誤處理和取消操作。

## 功能特色

- 📱 SwiftUI 介面設計
- ⬇️ 支援多種檔案大小下載 (100MB, 1GB, 10GB)
- 📊 即時下載進度顯示
- ❌ 支援下載取消功能
- ⚠️ 完整的錯誤處理機制
- 🏗️ 使用 Redux 架構模式進行狀態管理

## 系統需求

- iOS 15.0+
- Xcode 14.0+
- Swift 5.7+

## 專案架構

```
DownloadDemo/
├── API Model/          # 網路請求相關模型
│   ├── APIName.swift
│   ├── DownloadFileRequest.swift
│   ├── DownloadHandler.swift
│   └── DownloadRequest.swift
├── ViewModel/          # MVVM 架構的視圖模型
│   ├── DownloadAction.swift
│   ├── DownloadError.swift
│   ├── DownloadMiddleware.swift
│   ├── DownloadState.swift
│   ├── DownloadStore.swift
│   └── Store.swift
├── View/               # SwiftUI 視圖
│   └── MainView.swift
├── Assets.xcassets/    # 圖片資源
└── DownloadDemoApp.swift  # 應用程式進入點
```

## 主要元件說明

### DownloadStore
使用 Redux 模式的狀態管理容器，負責管理應用程式的下載狀態。

### DownloadAction
定義所有可能的下載動作：
- 開始下載
- 更新進度
- 完成下載
- 取消下載
- 錯誤處理

### MainView
主要的使用者介面，提供：
- 檔案大小選擇器
- 下載進度顯示
- 開始/取消下載按鈕
- 錯誤訊息提示

## 安裝與執行

1. 克隆此專案到本機：
```bash
git clone <repository-url>
cd DownloadDemo
```

2. 開啟 Xcode 專案：
```bash
open DownloadDemo.xcodeproj
```

3. 選擇目標裝置或模擬器，然後點擊執行按鈕。

## 使用方式

1. 啟動應用程式
2. 選擇要下載的檔案大小 (100MB / 1GB / 10GB)
3. 點擊 "Start Download" 開始下載
4. 觀察下載進度條
5. 可隨時點擊 "Cancel" 取消下載

## 技術特點

- **狀態管理**：採用 Redux 架構模式，確保狀態的可預測性
- **非同步處理**：使用 Swift Concurrency 處理網路請求
- **錯誤處理**：完整的錯誤處理機制，提供友善的錯誤訊息
- **使用者體驗**：即時的進度回饋和直觀的操作介面

## 依賴項目

- SwiftExtensions.xcframework：自訂的 Swift 擴充功能框架

## 授權條款

本專案採用 Apache License 2.0 授權條款。詳細內容請參閱 [LICENSE](LICENSE) 檔案。

---

如有任何問題或建議，歡迎提出 Issue 或 Pull Request。
