#if os(macOS)
import FluidAudio
import Foundation

/// Handler for the 'download' command - downloads benchmark datasets
enum DownloadCommand {
    private static let logger = AppLogger(category: "Download")
    static func run(arguments: [String]) async {
        var dataset = "all"
        var forceDownload = false

        // Parse arguments
        var i = 0
        while i < arguments.count {
            switch arguments[i] {
            case "--dataset":
                if i + 1 < arguments.count {
                    dataset = arguments[i + 1]
                    i += 1
                }
            case "--force":
                forceDownload = true
            default:
                logger.warning("Unknown option: \(arguments[i])")
            }
            i += 1
        }

        logger.info("📥 Starting dataset download")
        logger.info("   Dataset: \(dataset)")
        logger.info("   Force download: \(forceDownload ? "enabled" : "disabled")")

        switch dataset.lowercased() {
        case "librispeech-test-clean":
            let benchmark = ASRBenchmark()
            do {
                try await benchmark.downloadLibriSpeech(
                    subset: "test-clean", forceDownload: forceDownload)
            } catch {
                logger.error("Failed to download LibriSpeech test-clean: \(error)")
                exit(1)
            }
        case "librispeech-test-other":
            let benchmark = ASRBenchmark()
            do {
                try await benchmark.downloadLibriSpeech(
                    subset: "test-other", forceDownload: forceDownload)
            } catch {
                logger.error("Failed to download LibriSpeech test-other: \(error)")
                exit(1)
            }
        default:
            logger.error("Unsupported dataset: \(dataset)")
            printUsage()
            exit(1)
        }
    }

    private static func printUsage() {
        logger.info(
            """

            Download Command Usage:
                fluidaudio download [options]

            Options:
                --dataset <name>    Dataset to download (default: librispeech-test-clean)
                --force            Force re-download even if exists

            Available datasets:
                librispeech-test-clean  LibriSpeech test-clean subset
                librispeech-test-other  LibriSpeech test-other subset

            Examples:
                fluidaudio download --dataset librispeech-test-clean --force
            """
        )
    }
}
#endif
