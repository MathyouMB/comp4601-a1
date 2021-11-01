# COMP 4601 - A1

# Setup

1. Run Kafka docker-compose

```bash
docker-compose up
```

2. Run Realm

```bash
cd realm
rails s
```

3. Run Thessel

```bash
cd realm
bundle exec racecar Thessal
```

4. Run Arachna

```bash
cd arachna
npm run dev
```

# Kafka Topics

- page-crawl-complete
- page-crawl-enqueue

# Scripts

Create message
```bash
bash create-message.sh {topic name}
```

Create topic
```bash
bash create-topic.sh {topic name}
```
