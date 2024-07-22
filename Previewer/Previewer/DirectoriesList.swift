import SwiftUI

struct DirectoriesList: View {

    let directories: [Directory]

    var body: some View {
        List(directories) { directory in
            NavigationLink {
                Gallery(directory: directory)
            } label: {
                Label(
                    title: {
                        HStack {
                            Text(directory.path.lastPathComponent)
                            Spacer()
                            Text(directory.contents.count.description)
                        }
                        .padding(.horizontal, 16) },
                    icon: { Image(systemName: "folder").renderingMode(.template) }
                )
                .font(.title.monospaced())
                .foregroundStyle(Color(.labelColor))
                .padding(.leading, 16)
                .padding(.vertical, 4)
                .background(Color(.labelColor).opacity(0.2))
                .clipShape(.rect(cornerRadius: 8))
            }
        }
        .scrollContentBackground(.hidden)
        .gradient()
    }
}
