from kafka import KafkaConsumer, KafkaProducer
import networkx as nx
from ast import literal_eval
import json

print("Medusa is running... hisss....")

def format_edges(edges):
    edges_formatted = []

    # For each eache page in the graph
    for edge in edges:
        edge_formatted = (edge[0], edge[1], 1)
        edges_formatted.append(edge_formatted)

    return edges_formatted


def calculate_pagerank(edges):
    # Create blank graph
    network_graph = nx.DiGraph()

    # Format edges
    formatted_edges = format_edges(edges)

    f = open("demofile3.txt", "a")
    f.write(json.dumps(formatted_edges))
    f.close()

    # Feed page link to graph
    network_graph.add_weighted_edges_from(formatted_edges)

    # Return page rank for each page
    return nx.pagerank(network_graph)


def produce_message(crawl_id, page_ranks):
    # Format message
    message = {
        "crawl_id": crawl_id,
        "page_ranks": page_ranks
    }

    # Stringify message
    message_json = json.dumps(message, separators=(',', ':'))

    # Convert string to bytestring
    encoded_message = str.encode(message_json)

    # Send message to kafka
    producer.send('index_data_request_pagerank_complete', encoded_message)


producer = KafkaProducer(bootstrap_servers='localhost:9092')
consumer = KafkaConsumer('index_data_request_pagerank', group_id='medusa', bootstrap_servers='localhost:9092')
for msg in consumer:
    # Print message
    print("receive message.")
    # Convert byte string to dictionary
    # data = literal_eval(msg.value.decode('utf8'))
    data = json.loads(msg.value.decode('utf8'))
    # data = json.dumps(stringify_data, indent=4, sort_keys=True)

    # Retrieve data
    crawl_id = data.get("crawl_id")
    crawl_edges = data.get("crawl_edges")

    # Calculate pagerank
    page_ranks = calculate_pagerank(crawl_edges)
    produce_message(crawl_id, page_ranks)
