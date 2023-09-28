# scheduled-tasks

This is a set of resources I used to assist with threat hunting for anomalous tasks. 

This information was presented at ShmooCon 2023 and GrrCON 2023. 

## Powershell Analysis

`hunt-sched-tasks.ps1`

This script is to be used as methodology for hunting through scheduled tasks. It's intended to be ran line-by-line and can be expanded/contracted depending on your needs.

## Exporting to Elasticsearch

I plan to update this process to instead be a Logstash pipeline. Currently, this will export and convert the scheduled tasks (XML) to CSV documents for manual ingest.

Step 1 - Export the scheduled tasks
- Use the `export-schtasks.ps1` script

Step 2 - Convert the XML files to JSON
- Use the `xml-to-json.py` script

Step 3 - Conver the JSON to CSV (I realize there is probably an shorter path from XML to CSV, but my miserable journey took me this way...)
- I used a tool called SaveJSON2CSV (https://www.gunamoi.com.au/soft/savejson2csv/index.html)
- There are plenty of free tools out there to accomplish this!

Step 4 - Ingest into Elastic
- From the homepage, click "Add Data", then navigate to "Upload file"
- Note: This location has changed depending on what version of Elastic you are running - In my sample environment I am using Elasticsearch and Kibana v7.15.2


## Elastic Containers

These images contain some sample scheduled tasks from a fresh build of Windows 10, including one malicous scheduled task. 

Pull the images:
```bash
docker pull oofles/schtasks-elasticsearch
docker pull oofles/schtasks-kibana
```

Start the environment:
```bash
docker network create schtasks-elastic
docker run -d --name schtasks-elasticsearch --net schtasks-elastic -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" oofles/schtasks-elasticsearch
docker run -d --name schtasks-kibana --net schtasks-elastic -p 5601:5601 -e "ELASTICSEARCH_HOSTS=http://schtasks-elasticsearch:9200/" oofles/schtasks-kibana 
```

### Dashboards
A copy of the dashboards for your own use is here in the same repo (`elastic-dashboards-schtasks.ndjson`). 

To import the visualizations and dashboards, navigate to "Stack Management" -> "Saved Objects" (Under Kibana), then click "Import"


## Misc.

In the presentation I also used a jq line to convert from JSON to NDJSON - including that here for reference:
```bash
cat test.json | jq -c '.[]' > testNDJSON.json
```
