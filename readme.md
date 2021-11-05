# COMP 4601 - A1
<img src="./documentation/architecture.png">
# Setup

1. Run Kafka docker-compose

```bash
docker-compose up
```

2. Run Oryx

```bash
cd realm
bundle install
rails db:setup

rails s
```

3. Run Thessel

```bash
cd realm
bundle install
rails db:setup

bundle exec racecar Thessal
```

4. Run Arachna

```bash
cd arachna
npm install

npm run dev
```

4. Run Septavius

```bash
cd septavius
npm install

npm run dev
```

5. Run Medusa
```bash
cd medusa
virtualenv venv -p python3
source venv/bin/activate
pip install -r requirements.txt

python application.py
```

6. Run Sentinel
```bash
cd sentinel
mix deps.get

mix run --no-halt
```


# Kafka Topics

- page-crawl-enqueue
- page-crawl-complete
- index_data_request
- index_data_request_pagerank
- index_data_request_pagerank_complete
- index_data_request_complete

# Scripts

Create message
```bash
bash create-message.sh {topic name}
```

Create topic
```bash
bash create-topic.sh {topic name}
```
