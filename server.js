const http = require('http');
const fs = require('fs');
const PORT = 5001;

const contentRead = fs.readFileSync('response.json');

var index = function (req, res) {
  res.writeHead(200, {
    'Content-Type': 'application/json'
  });
  res.write(JSON.stringify(JSON.parse(contentRead)));
  res.end();
};

var server = http.createServer((req, res) => {
  switch (req.url) {
  case '/':
    if (req.method === 'GET') {
      index(req, res);
    } else {
      res.writeHead(400);
      res.end();
    }
    break;
  default:
    res.writeHead(400);
    res.end();
    return;
  }
});

server.listen(PORT, () => {
  console.log('Listening at:', PORT);
});
