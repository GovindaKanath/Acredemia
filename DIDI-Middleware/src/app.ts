import express = require("express");
import { agent } from './veramo/setup'
var bodyParser = require('body-parser')

const INFURA_PROJECT_ID = '138d8c81f4104b9791525d78cc6d7622';

// Our Express APP config
const app = express();
app.set("port", process.env.PORT || 3000);
app.use(bodyParser.urlencoded({ extended: false }));

// create application/json parser
var jsonParser = bodyParser.json()


// API Endpoints
app.get("/", async (req, res) => {
  const identifiers = await agent.didManagerFind()
  if (identifiers.length > 0) {
    res.send(identifiers);
  }else {
    res.send("Hi");
  }
});

app.post("/", jsonParser, async (req, res) => {
  const { username } = req.body;
  const identity = await agent.didManagerCreate()
  res.send(identity);
});

// export our app
export default app;