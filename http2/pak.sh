#!/bin/bash

#gzip -9 -k -c main.html styles.css > main.gz
gzip -9 -k -c main.html > main.html.gz
7z a -mx9 main.html2.gz main.html
gzip -l main.html.gz main.html2.gz