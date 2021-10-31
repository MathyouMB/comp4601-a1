// Required module (install via NPM)
const Crawler = require("crawler");
let count = 0;

const c = new Crawler({
  rateLimit: 1000,
  maxConnections: 1,

  callback: function (error, res, done) {
    if (error) {
      console.log(error);
    } else {
      console.log("-----")
      let $ = res.$; // get cheerio data, see cheerio docs for info
      console.log(res.body);
      c.queue("https://people.scs.carleton.ca/~davidmckenney/fruitgraph/N-0.html");
      count += 1;
      console.log(count);
    }
    done();
  },
});

c.on("drain", function () {
  console.log("Done.");
});

c.queue("https://people.scs.carleton.ca/~davidmckenney/fruitgraph/N-0.html");
