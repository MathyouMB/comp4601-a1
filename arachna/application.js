const Crawler = require("crawler");
const { Kafka } = require("kafkajs");

// Kafka --------------------------------------------------------------------
const kafka = new Kafka({
  clientId: "arachna",
  brokers: ["localhost:9092"],
});

// consumer
const consumer = kafka.consumer({ groupId: "test-group" });
const run = async () => {
  await consumer.connect();
  await consumer.subscribe({
    topic: "page-crawl-enqueue",
    fromBeginning: true,
  });
  await consumer.run({
    eachMessage: async ({ topic, partition, message }) => {
      // print message information
      console.log({
        topic,
        partition,
        offset: message.offset,
        value: message.value.toString(),
      });

      // enqueue url if valid
      if (validateUrl(message.value.toString())) {
        crawler.queue(message.value.toString());
      } else {
        console.log("Invalid URL");
      }
    },
  });
};
run().catch(console.error);

// producer
const producer = kafka.producer();
const produceMessage = async (message) => {
  console.log("produce message");
  await producer.connect();
  await producer.send({
    topic: "page-crawl-complete",
    messages: [{ value: "Hello KafkaJS user!" }],
  });
  await producer.disconnect();
};

// Crawler --------------------------------------------------------------------
const crawler = new Crawler({
  rateLimit: 1000,
  maxConnections: 1,

  callback: function (error, res, done) {
    if (error) {
      console.log(error);
    } else {
      let $ = res.$; // get cheerio data, see cheerio docs for info
      console.log(res.body);
      produceMessage("this doesn't do anything yet");
    }
    done();
  },
});

crawler.on("drain", function () {
  console.log("No pages currently enqueued.");
});

// Methods --------------------------------------------------------------------
const validateUrl = (url) => {
  const urlRegex =
    /^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$/;
  return urlRegex.test(url);
};

/*
crawler.queue(
  "https://people.scs.carleton.ca/~davidmckenney/fruitgraph/N-0.html"
);
*/
