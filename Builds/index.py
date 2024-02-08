#!/usr/bin/env python3

from http.server import SimpleHTTPRequestHandler

SERVER = "https://13fb-14-139-174-50.ngrok-free.app"


class handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header('Set-Cookie', 'server-ip={}'.format(SERVER))
        super().end_headers()
