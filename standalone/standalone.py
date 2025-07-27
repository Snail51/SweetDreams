import http.server
import socketserver
import os
import webbrowser

PORT = 8000

def start_server():
    handler = http.server.SimpleHTTPRequestHandler

    # Change the current working directory to _internal
    os.chdir("_internal")
    
    # Create server instance
    with socketserver.TCPServer(("", PORT), handler) as httpd:
        print(f"Serving files at http://localhost:{PORT}")

        # Open the URL in a web browser
        url = f"http://localhost:{PORT}"
        webbrowser.open(url)

        httpd.serve_forever()

if __name__ == "__main__":
    start_server()

# pyinstaller ./standalone.spec