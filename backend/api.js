const http = require('http');
const request = require('request');
const cors = require('cors');

const express = require('express');
const app = express();

app.use(cors({
  origin: 'http://localhost:3000'
}));

const server = http.createServer(app);

app.post('/api', (req, res) => {
  let body = '';
  req.on('data', chunk => {
    body += chunk.toString();
  });

  req.on('end', () => {
    request(body, (error, response, html) => {
      if (error) {
        res.status(500).send('Error fetching API data');
      } else {
        res.status(response.statusCode).send(html);
      }
    });
  });
});

server.listen(5000, () => {
  console.log('Server started on port 5000');
});