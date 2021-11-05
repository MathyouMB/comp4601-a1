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
      // format message
      const formatted_message = JSON.parse(message.value.toString());

      // print message information
      console.log({
        topic,
        partition,
        offset: message.offset,
        value: formatted_message,
      });

      // enqueue url if valid
      if (validateUrl(formatted_message.url)) {
        crawler.queue(formatted_message.url);
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
  await producer.connect();
  await producer.send({
    topic: "page-crawl-complete",
    messages: [{ value: message }],
  });
  await producer.disconnect();
};

// Crawler --------------------------------------------------------------------
const crawler = new Crawler({
  rateLimit: 100,
  maxConnections: 10,

  callback: function (error, res, done) {
    if (error) {
      console.log(error);
    } else {
      if (
        !res.options.uri.endsWith(".pdf") ||
        !res.options.uri.endsWith(".doc") ||
        !res.options.uri.endsWith(".xlsx")
      ) {
        let $ = res.$;
        let links = prepareLinks(res.options.uri, $("a").get());
        let message = formatMessage(
          $("title").text(),
          res.options.uri,
          $("body").text(),
          links
        );

        produceMessage(message);
      }
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

const formatMessage = (title, url, html, links) => {
  return JSON.stringify({
    title: title,
    url: url,
    html: html,
    links: links,
  });
};

const prepareLinks = (origin, links) => {
  let filteredLinks = filterLinks(links);
  formattedLinks = formatLinks(origin, filteredLinks);
  convertedLinks = convertExternalHashLinks(formattedLinks);
  linkStrings = urlsToStrings(convertedLinks);
  return linkStrings;
};

const formatLinks = (origin, links) => {
  let formattedLinks = [];
  links.forEach((e) => {
    absolute_url = new URL(e.attribs.href, origin).href;
    formattedLinks.push(absolute_url);
  });
  return formattedLinks;
};

const filterLinks = (links) => {
  let filterLinks = [];
  links.forEach((e) => {
    if ("href" in e.attribs) {
      if (!e.attribs.href.startsWith("#")) {
        filterLinks.push(e);
      }
    }
  });
  return filterLinks;
};

const convertExternalHashLinks = (links) => {
  let convertedLinks = [];
  links.forEach((e) => {
    const link = new URL(e);
    if (link.hash.length > 0) {
      let convertedLink = e.substring(0, link.length - link.hash.length);
      convertedLinks.push(convertedLink);
    } else {
      convertedLinks.push(link);
    }
  });
  return convertedLinks;
};

const urlsToStrings = (urls) => {
  let urlsAsStrings = [];
  urls.forEach((e) => {
    urlsAsStrings.push(e.href);
  });
  return urlsAsStrings;
};

/*
crawler.queue(
  "https://people.scs.carleton.ca/~davidmckenney/fruitgraph/N-0.html"
);
*/
