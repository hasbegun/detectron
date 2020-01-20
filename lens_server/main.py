import os.path
import tornado.httpserver
import tornado.ioloop
import tornado.web
from tornado.options import define, options
import string, random
import uuid
# import asyncio
import aiofiles as aiof
import logging

define("port", default=8888, help="Run on the given port", type=int)
define("log_level", default='INFO', help="Define log level. Default is INFO", type=string)

if options.log_level == "INFO":
    level = logging.INFO
elif options.log_level == "DEBUG":
    level = logging.DEBUG
elif options.log_level == "WARN":
    level = logging.WARN
elif options.log_level == "ERROR":
    level = logging.ERROR

logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                    level=level)

logger = logging.getLogger(__name__)
class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/dropfile", DropFileHandler),
            (r"/upload", UploadHandler),
        ]
        tornado.web.Application.__init__(self, handlers)

class DropFileHandler(tornado.web.RequestHandler):
    def get(self):
        # self.write('server is running....')
        self.render("www/upload_form.html")
    def post(self):
        pass

class UploadHandler(tornado.web.RequestHandler):
    # async def write_to_disk(self, fname, content):
    #     with open(fname, 'wb') as f:
    #         await f.write(content)
    #     print("File %s is uploaded." % fname)

    def set_default_headers(self):
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "x-requested-with")
        self.set_header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS')

    async def post(self):
        for _, files in self.request.files.items():
            for info in files:
                filename, content_type = info['filename'], info['content_type']
                logger.debug('Uploading file: ', filename)
                logger.debug('content type: ', content_type)
                body = info['body']
                # todo: 1. save it only img and video. no other types.
                # todo: 2. support multiple.... maybe multi thread..... async
                # todo: 3. limit the size
                fname = '%s_%s' %(filename, str(uuid.uuid4()))
                extenstion = os.path.splitext(filename)[1] if os.path.splitext(filename)[1] else '.jpg'
                final_filename = fname + extenstion

                async with aiof.open('uploads/%s' % final_filename, 'wb') as f:
                    await f.write(body)
                    await f.flush()
                self.finish("File %s is uploaded." % final_filename)


def main():
    http_server = tornado.httpserver.HTTPServer(Application())
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()

if __name__ == '__main__':
    main()
