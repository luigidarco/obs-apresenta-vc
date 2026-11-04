import http from'node:http';http.createServer((_req,res)=>{res.writeHead(302,{Location:'http://127.0.0.1:17862/'});res.end()}).listen(17861,'127.0.0.1');
