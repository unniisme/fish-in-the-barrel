#!/usr/bin/env python3

from http.server import SimpleHTTPRequestHandler
import os

SERVER = "https://13fb-14-139-174-50.ngrok-free.app"


class handler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header('Set-Cookie', 'server-ip={}'.format(SERVER))
        super().end_headers()

    def do_GET(self):
        # Set the MIME type to text/html
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

        # Open and read the HTML file
        with open('/build/game.html', 'rb') as file:
            html_content = file.read()

        print(html_content)

        # Write the HTML content to the response
        self.wfile.write(html_content)
