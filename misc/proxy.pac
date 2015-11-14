function FindProxyForURL(url, host) {
    if (shExpMatch(host, "*.dev.scaleout.jp")) {
        return "SOCKS localhost:1081;SOCKS5 localhost:1081";
    } else if (shExpMatch(host, "*.dc1p.scaleout.jp")) {
        return "SOCKS localhost:1080;SOCKS5 localhost:1080";
    } else if (shExpMatch(host, "*.dc2p.scaleout.jp")) {
        return "SOCKS localhost:1080;SOCKS5 localhost:1080";
    } else if (shExpMatch(host, "*.tkl.iis.u-tokyo.ac.jp")) {
        return "SOCKS localhost:1082;SOCKS5 localhost:1082";
    } else {
        return "DIRECT";
    }
}
