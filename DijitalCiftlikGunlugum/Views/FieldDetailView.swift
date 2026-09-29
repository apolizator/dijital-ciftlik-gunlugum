import SwiftUI
import SwiftData

/// Tek bir tarlanın detay ekranı: durum başlığı, zaman tüneli ve notlar.
struct FieldDetailView: View {
    @Bindable var field: Field

    @State private var selectedTab: Tab = .timeline
    @State private var showingAddActivity = false
    @State private var showingAddNote = false

    enum Tab: String, CaseIterable {
        case timeline = "Zaman Tüneli"
        case notes = "Notlar"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                header
                picker
                content
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(field.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        showingAddActivity = true
                    } label: {
                        Label("İşlem Gir", systemImage: "plus.square.on.square")
                    }
                    Button {
                        showingAddNote = true
                    } label: {
                        Label("Not Ekle", systemImage: "note.text.badge.plus")
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddActivity) {
            AddActivityView(field: field)
        }
        .sheet(isPresented: $showingAddNote) {
            AddNoteView(field: field)
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(spacing: 12) {
            HStack {
                Label(field.status.label, systemImage: field.status.systemImage)
                    .font(.subheadline.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(field.status.color.opacity(0.15))
                    .foregroundStyle(field.status.color)
                    .clipShape(Capsule())
                Spacer()
            }

            HStack {
                infoTile(value: "\(AppFormat.area(field.area))", unit: "dönüm")
                Divider().frame(height: 36)
                infoTile(value: "\(field.daysInCurrentStatus)", unit: "gündür bu durumda")
                Divider().frame(height: 36)
                infoTile(
                    value: field.cropName.isEmpty ? "—" : field.cropName,
                    unit: "ekili ürün"
                )
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private func infoTile(value: String, unit: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.headline)
            Text(unit)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }

    private var picker: some View {
        Picker("Görünüm", selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Text(tab.rawValue).tag(tab)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .timeline: timeline
        case .notes:    notes
        }
    }

    @ViewBuilder
    private var timeline: some View {
        let items = field.sortedActivities
        if items.isEmpty {
            placeholder(
                icon: "calendar.badge.clock",
                text: "Henüz işlem girilmedi.\nSağ üstten 'İşlem Gir' ile başla."
            )
        } else {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.element.persistentModelID) { index, item in
                    TimelineRowView(
                        activity: item,
                        isFirst: index == 0,
                        isLast: index == items.count - 1
                    )
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    @ViewBuilder
    private var notes: some View {
        let items = field.sortedNotes
        if items.isEmpty {
            placeholder(
                icon: "note.text",
                text: "Henüz not yok.\nSes, fotoğraf veya yazıyla ilk notunu ekle."
            )
        } else {
            VStack(spacing: 12) {
                ForEach(items, id: \.persistentModelID) { note in
                    NoteRowView(note: note)
                }
            }
        }
    }

    private func placeholder(icon: String, text: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(text)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

#Preview {
    NavigationStack {
        FieldDetailView(field: PreviewData.sampleField)
    }
    .modelContainer(PreviewData.container)
}
