import http.server
import socketserver
import os
import webbrowser

PORT = 8080

def start_server():
    handler = http.server.SimpleHTTPRequestHandler

    # Change the current working directory to _internal
    path = os.path.dirname(os.path.abspath(__file__))
    path = path.rstrip('/_internal')
    path = path + "/_internal"
    print("Document Root: " + path)
    os.chdir(path)
    
    # Create server instance
    try:
        with socketserver.TCPServer(("", PORT), handler) as httpd:
            print(f"Serving files at http://localhost:{PORT}")
            
            # Open the URL in a web browser
            url = f"http://localhost:{PORT}"
            webbrowser.open(url)
            
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer shutting down...")
        httpd.server_close()

if __name__ == "__main__":
    start_server()

# pyinstaller ./standalone.spec