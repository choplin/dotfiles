function FindProxyForURL(url, host) {
    if (shExpMatch(host, "*.dev.scaleout.jp")) {
        return "SOCKS5 localhost:1081";
    } else if (shExpMatch(host, "*.dc1p.scaleout.jp")) {
        return "SOCKS5 localhost:1080";
    } else {
        return "DIRECT";
    }
}
