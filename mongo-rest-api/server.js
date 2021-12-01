const express = require('express');
const cors = require('cors');
const dbo = require('./js/connect');

const PORT = 5000;
const app = express();

app.use(cors());
app.use(express.json());
app.use(require('./js/routes'));


// Global error handling
app.use(function (err, _req, res) {
  console.error(err);
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

// perform a database connection when the server starts
dbo.connectToServer(function (err) {
  if (err) {
    console.error(err);
    process.exit();
  }

  // start the Express server
  app.listen(PORT, () => {
    console.log(`http://localhost:5000/hlasy`);
  });
});
