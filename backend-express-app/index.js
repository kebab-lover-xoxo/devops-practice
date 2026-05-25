const express = require('express');
const app = express();
const port = process.env.PORT || 4000;

app.use(express.json());

app.get('/api', (req, res) => {
  res.json({ message: 'Hello from Express backend!' });
});

app.post('/api/echo', (req, res) => {
  res.json({ body: req.body });
});

app.listen(port, () => {
  console.log(`Express backend listening on http://0.0.0.0:${port}`);
});
