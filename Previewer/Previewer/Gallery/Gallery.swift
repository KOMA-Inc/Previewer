import SwiftUI

struct Gallery: View {

    @StateObject private var viewModel: GalleryViewModel
    @EnvironmentObject private var appStorage: AppStorage

    init(directory: Directory) {
        self._viewModel = StateObject(wrappedValue: GalleryViewModel(directory: directory))
    }

    private var contents: [Picture] {
        viewModel.contents
    }

    private let columns: [GridItem] = [
        GridItem(.flexible(minimum: 50, maximum: .infinity)),
        GridItem(.flexible(minimum: 50, maximum: .infinity)),
        GridItem(.flexible(minimum: 50, maximum: .infinity))
    ]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach($viewModel.features, id: \.wrappedValue.key) { feature in
                    Section {
                        ForEach(feature.values, id: \.name) { value in
                            HStack {
                                Toggle(isOn: value.isActive) {
                                    Text(value.wrappedValue.name)
                                }
                            }
                        }
                    } header: {
                        Text(feature.wrappedValue.key)
                            .font(.title)
                    }
                }
            }
            .monospaced()
        } detail: {
            GeometryReader { proxy in
                ScrollView {
                    LazyVGrid(
                        columns: .init(
                            repeating: GridItem(.flexible(minimum: 500, maximum: .infinity)),
                            count: Int(proxy.size.width / 500)
                        ),
                        spacing: 16
                    ) {
                        ForEach(contents.indices, id: \.self) { idx in
                            VStack {

                                let picture = contents[idx]
                                let url = picture.path

                                Text("\(idx + 1) / \(contents.count)")
                                    .font(.caption.monospacedDigit())

                                Image(nsImage: NSImage(data: try! Data(contentsOf: url))!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 500)
                                    .onTapGesture {
                                        if appStorage.isValidPicture(picture) {
                                            appStorage.addPicture(picture)
                                        } else {
                                            appStorage.removePicture(picture)
                                        }
                                    }
                                    .overlay {
                                        if !appStorage.isValidPicture(contents[idx]) {
                                            Color.black.opacity(0.5)
                                                .allowsHitTesting(false)
                                                .overlay {
                                                    Image(systemName: "xmark.circle")
                                                        .resizable()
                                                        .frame(width: 100, height: 100)
                                                        .foregroundStyle(.red)
                                                }
                                        }
                                    }
                                    .animation(.easeInOut(duration: 0.2), value: appStorage.isValidPicture(picture))

                                Text(url.lastPathComponent)
                                    .textSelection(.enabled)
                            }
                        }
                    }
                    .padding()
                }
                .animation(.default, value: viewModel.contents)
                .searchable(text: $viewModel.searchInput)
            }
            .frame(minWidth: 550)
        }
    }
}
