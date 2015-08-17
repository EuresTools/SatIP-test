# SatIP-test

This is only the product of some fiddling around with libraries and the app does not have any significant functionality. What it does is discover Sat>IP servers on the network via SSDP.

I used [CocoaSSDP](https://github.com/sboisson/CocoaSSDP) for the discovery. Candidate libraries to use for the actual RTSP connection and stream are [MobileVLCKit](https://code.videolan.org/videolan/VLCKit) and the [FFmpegWrapper](https://github.com/OpenWatch/FFmpegWrapper) for iOS.

[DFURTSPPlayer](https://github.com/durfu/DFURTSPPlayer) is a working example of a RTSP streaming application for iOS.
