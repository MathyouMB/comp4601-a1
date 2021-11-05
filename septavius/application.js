const express = require("express");
const bodyParser = require("body-parser");
const elasticlunr = require("elasticlunr");
const { Kafka } = require("kafkajs");
const fs = require("fs");

// Express --------------------------------------------------------------------
const controller = express();
const port = 4000;
controller.set("port", port);
controller.use(bodyParser.json());
controller.use(bodyParser.urlencoded({ extended: true }));

controller.get("/", async (req, res) => {
  res.json({ data: {} });
});

controller.get("/search/:crawl_id", async (req, res) => {
  // load index based on crawl_id
  let index = loadIndex(req.params.crawl_id);

  // search
  const searchResults = index.search(req.query.q);

  // determine if we should boost results by page rank
  const boost = determineBoosted(req.query.boost)

  // boost results by page rank (only happens if boost is true)
  const results = determineBoostedResults(boost, searchResults, index)

  // convert results to documents
  const resultsSlice = results.slice(0, determineLimit(req.query.limit));

  /* get documents from results
  const documents = resultsSlice.map((result) => {
    return index.documentStore.getDoc(result.ref);
  });
  */

  // get ids from resultsSlice
  const ids = resultsSlice.map((result) => {
    return result.ref;
  });

  // return documents
  res.json({ data: ids });
});

controller.post("/enqueue_index_creation", async (req, res) => {
  // if we do not have an index, ask kafka
  produceMessage(
    "index_data_request",
    JSON.stringify({ crawl_id: req.body.crawl_id })
  );

  // return success
  res.json({
    message: `Succesfully enqueued creation of index for Crawl: ${req.body.crawl_id}`,
  });
});

controller.listen(port, () => {
  console.log(`Septavius is listening at http://localhost:${port}`);
});

// Kafka --------------------------------------------------------------------
const kafka = new Kafka({
  clientId: "septavius",
  brokers: ["localhost:9092"],
});

// consumer
const consumer = kafka.consumer({ groupId: "septavius" });
const run = async () => {
  await consumer.connect();
  await consumer.subscribe({
    topic: "index_data_request_complete",
    fromBeginning: true,
  });
  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      // format message
      const formatted_message = JSON.parse(message.value.toString());

      // print message information
      console.log({
        topic,
        partition,
        offset: message.offset,
      });

      if (topic == "index_data_request_complete") {
        createPageIndex(formatted_message.crawl_id, formatted_message.pages);
      }
    },
  });
};
run().catch(console.error);

// producer
const producer = kafka.producer();
const produceMessage = async (topic, message) => {
  console.log("produce");
  await producer.connect();
  await producer.send({
    topic: topic,
    messages: [{ value: message }],
  });
  await producer.disconnect();
};

// Methods --------------------------------------------------------------------
const createPageIndex = (crawl_id, pages) => {
  const index = elasticlunr(function () {
    this.setRef("id");
    this.addField("html");
    this.addField("title");
    this.addField("url");
  });

  pages.forEach((page) => {
    console.log(page.url);
    index.addDoc(page);
  });

  fs.writeFileSync(`./indexes/${crawl_id}.json`, JSON.stringify(index));
  console.log("Saved index.");
};

const loadIndex = (crawl_id) => {
  const data = fs.readFileSync(`./indexes/${crawl_id}.json`, "utf8");
  return elasticlunr.Index.load(JSON.parse(data));
};

const determineLimit = (limit) => {
  return limit != undefined && limit >= 1 && limit <= 50 ? limit : 10;
};

const determineBoosted = (boost) => {
  return boost != undefined && boost == 'true' ? true : false;
};

const determineBoostedResults = (boost, results, index) => {
  // if we are not boosting, return results
  if (!boost) {
    return results
  }

  // load documents (the full documents)
  const documents = results.map((result) => {
    return index.documentStore.getDoc(result.ref);
  });

  // for each result, multiply score by page rank
  const boosted_results = results.map((result) => {
    const doc = documents.find((doc) => {
      return doc.id == result.ref;
    });
    return {
      ...result,
      score: result.score * doc.page_rank,
    };
  });

  // sort by score
  boosted_results.sort((a, b) => {
    return a.score < b.score;
  });

  return boosted_results;
}
