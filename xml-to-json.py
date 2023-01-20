#!/usr/bin/python3
# Python script to convert all XML files in a directory to JSON
# Author: ViviCat

import xmltodict, json, os

directory = '/some/directory/'

for filename in os.listdir(directory):
    if filename.endswith(".xml"):
        with open(filename, 'rb') as f:

            XML_content = f.read()

            x = xmltodict.parse(XML_content)
            j = json.dumps(x)

            print (filename)

            filename = filename.replace('.xml', '')
            output_file = open(filename + '.json', 'w')
            output_file.write(j)
