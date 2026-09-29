import SwiftUI
import SwiftData

/// Uygulamanın ana ekranı: tüm tarlaların kart listesi.
struct DashboardView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Field.createdAt, order: .reverse) private var fields: [Field]

    @State private var showingAddField = false

    var body: some View {
        NavigationStack {
            Group {
                if fields.isEmpty {
                    emptyState
                } else {
                    fieldList
                }
            }
            .navigationTitle("Tarlalarım")
            .background(Color(.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddField = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddField) {
                AddFieldView()
            }
        }
    }

    private var fieldList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(fields) { field in
                    NavigationLink {
                        FieldDetailView(field: field)
                    } label: {
                        FieldCardView(field: field)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        Button(role: .destructive) {
                            context.delete(field)
                        } label: {
                            Label("Tarlayı Sil", systemImage: "trash")
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("Henüz tarla yok", systemImage: "map")
        } description: {
            Text("İlk tarlanı eklemek için sağ üstteki + düğmesine dokun.")
        } actions: {
            Button("Tarla Ekle") { showingAddField = true }
                .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(PreviewData.container)
}
