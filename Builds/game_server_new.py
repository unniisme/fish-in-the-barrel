#!/usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler, test  # type: ignore
from urllib.parse import urlparse, parse_qs
from pathlib import Path
import os
import sys
import argparse
import subprocess
import ssl
import json

CERT = "ssl/cert.pem"
KEY = "ssl/key.pem"

SERVER = "https://13fb-14-139-174-50.ngrok-free.app"


class CORSRequestHandler(SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header('Set-Cookie', 'server-ip={}'.format(SERVER))
        super().end_headers()


def shell_open(url):
    if sys.platform == "win32":
        os.startfile(url)
    else:
        opener = "open" if sys.platform == "darwin" else "xdg-open"
        subprocess.call([opener, url])


def serve(root, port, run_browser):
    os.chdir(root)

    if run_browser:
        # Open the served page in the user's default browser.
        print("Opening the served URL in the default browser (use `--no-browser` or `-n` to disable this).")
        shell_open(f"http://127.0.0.1:{port}")

    test(CORSRequestHandler, HTTPServer, port=port)

def serve_secure(root, port, run_browser):
    os.chdir(root)
    if run_browser:
        print("Opening the served URL in the default browser (use `--no-browser` or `-n` to disable this).")
        shell_open(f"https://127.0.0.1:{port}")

    # Use SSL certificate and key
    httpd = HTTPServer(('0.0.0.0', port), CORSRequestHandler)
    httpd.socket = ssl.wrap_socket(httpd.socket, certfile=CERT, keyfile=KEY, server_side=True)
    httpd.serve_forever()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-p", "--port", help="port to listen on", default=8060, type=int)
    parser.add_argument(
        "-r", "--root", help="path to serve as root (relative to `platform/web/`)", default=".", type=Path
    )
    browser_parser = parser.add_mutually_exclusive_group(required=False)
    browser_parser.add_argument(
        "-n", "--no-browser", help="don't open default web browser automatically", dest="browser", action="store_false"
    )
    parser.set_defaults(browser=True)
    args = parser.parse_args()

    # Change to the directory where the script is located,
    # so that the script can be run from any location.
    os.chdir(Path(__file__).resolve().parent)

    serve_secure(args.root, args.port, args.browser)

