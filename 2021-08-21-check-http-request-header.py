import SimpleHTTPServer
import SocketServer

class ServerHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    def do_GET(self):
        print(self.headers)
        SimpleHTTPServer.SimpleHTTPRequestHandler.do_GET(self)

Handler = ServerHandler
SocketServer.TCPServer(("", 80), Handler).serve_forever()