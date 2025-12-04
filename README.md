# 🗺️ My_Journey

**My_Journey** ist eine einfache, aber effektive iOS-App, die entwickelt wurde, um die Planung und Verwaltung deiner Reisen zu vereinfachen. Erfasse alle wichtigen Details, von der Route über das Transportmittel bis hin zu Notizen und Packlisten, zentral an einem Ort.
    Dies ist mein Beitrag für den Minihackathon 3.0 zum Thema Unordnung

## ✨ Funktionen im Überblick

* **Reiseübersicht:** Zeige alle geplanten Reisen in einer übersichtlichen Liste an, sortiert nach dem Startdatum.
* **Neuanlage:** Füge neue Reisen einfach mit Startort, Zielort, Datum und gewähltem **Transportmittel** hinzu.
* **Reise-Details:** Eine dedizierte Ansicht für jede Reise mit:
    * **Kartenansicht:** Darstellung der Route (Start und Ziel) mithilfe von **MapKit** und Geocoding.
    * **Zusatz-Infos:** Füge schnell Notizen oder wichtige Informationen hinzu und verwalte sie.
    * **Packliste:** Verwalte eine dedizierte Packliste für jede Reise, um sicherzustellen, dass nichts vergessen wird.
* **Datenhaltung:** Nutzung von **SwiftData** für die persistente Speicherung aller Reiseinformationen.
* **Bearbeitung/Löschung:** Einfaches Löschen von Reisen und Verwalten (Hinzufügen/Entfernen) von Elementen in der Packliste und den Infos.

---

## 🛠️ Technologie

Die App wurde nativ für Apple-Plattformen entwickelt und nutzt moderne Frameworks:

| Komponente | Beschreibung |
| :--- | :--- |
| **Framework** | **SwiftUI** für die gesamte Benutzeroberfläche. |
| **Datenbank** | **SwiftData** (`Journey` Model) für lokale, persistente Datenspeicherung. |
| **Karten & Ortung** | **MapKit** und **CoreLocation** (`CLGeocoder`) zur Bestimmung der Koordinaten von Start- und Zielorten. |
| **Sprache** | Swift (Moderne Syntax und asynchrone Programmierung mit `async/await`). |

---

## 📁 Projektstruktur (Wichtige Views)

Das Projekt organisiert die verschiedenen Funktionen in dedizierten SwiftUI-Views und einem zentralen Model.

| Datei | Beschreibung |
| :--- | :--- |
| **`ContentView.swift`** | Die **Hauptansicht** (Home Screen). Listet alle Reisen auf und dient als Einstiegspunkt für die Navigation. |
| **`DetailView.swift`** | Die **detaillierte Ansicht** einer Reise. Beinhaltet die Map-Logik, Geocoding und die Anzeige der Infos. |
| **`NewJourneyView.swift`** | Die **Formularansicht** zum Erstellen neuer Reisen. |
| **`PackingListView.swift`** | Ansicht zur **Verwaltung der Packliste** (Hinzufügen und Löschen von Gegenständen). |
| **`AddInfoView.swift`** | Ansicht zum **Hinzufügen zusätzlicher Notizen** zu einer Reise. |
| **`Journeys.swift`** | Enthält das **SwiftData-Model `Journey`** und das Enum `VehicleType`. |

---

## 🚀 Installation

1.  Öffne das Projekt in **Xcode** (mindestens Version 15+ erforderlich).
2.  Stelle sicher, dass du das iOS-Simulator- oder Geräteziel ausgewählt hast.
3.  Führe das Projekt aus (Cmd + R).

## 📝 Datenmodell (`Journey.swift`)

Das zentrale Datenmodell für jede Reise.

```swift
@Model
class Journey {
    var destination: String
    var start: String
    var startDate: Date
    var vehicle: String // Speichert den RawValue des VehicleType Enums
    var infos: [String]?    // Zusätzliche Notizen
    var packlist: [String]? // Liste der benötigten Gegenstände
    // ...
}
