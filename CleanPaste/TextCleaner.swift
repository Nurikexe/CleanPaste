import Foundation

struct TextCleaner {
    func clean(_ text: String) -> String {
        let normalizedText = text
            .replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n")
            .replacingOccurrences(
                of: #"\n[ \t]*\n+"#,
                with: "\u{0B}",
                options: .regularExpression
            )

        let paragraphs = normalizedText
            .components(separatedBy: "\u{0B}")
            .map { cleanParagraph($0) }
            .filter { !$0.isEmpty }

        return paragraphs.joined(separator: "\n\n")
    }

    private func cleanParagraph(_ paragraph: String) -> String {
        var cleaned = paragraph.trimmingCharacters(in: .whitespacesAndNewlines)

        cleaned = cleaned.replacingOccurrences(
            of: #"(?<=\p{L})-\s*\n\s*(?=\p{L})"#,
            with: "",
            options: .regularExpression
        )

        cleaned = cleaned.replacingOccurrences(
            of: #"[ \t]*\n[ \t]*"#,
            with: " ",
            options: .regularExpression
        )

        cleaned = cleaned.replacingOccurrences(
            of: #"[ \t]{2,}"#,
            with: " ",
            options: .regularExpression
        )

        cleaned = cleaned.replacingOccurrences(
            of: #"\s+([,.;:!?])"#,
            with: "$1",
            options: .regularExpression
        )

        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
