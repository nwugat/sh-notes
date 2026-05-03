#!/usr/bin/env python

# take unprocessed tag list from STDIN
# filter it so each element is uniq and contains occurence number
# takes nested tags into account

import sys

tag_strings = sys.stdin.read().strip().split("\n")
# 2D matrix: col 0 contains tags, col 1 contains occurrence number
processed_tags = []

def get_processed_tag(tag):
    for item in processed_tags:
        if item[0].__eq__(tag):
            return item
    return None

for tag in tag_strings:
    tag_parts = tag.split("/")
    reconstructed_tag = ""
    for part in tag_parts:
        # for a/b/c/d: a, a/b, a/b/c, ...
        reconstructed_tag += "/" + part
        reconstructed_tag = reconstructed_tag.strip("/")
        processed_tag = get_processed_tag(reconstructed_tag)
        if processed_tag == None:
            processed_tags.append([reconstructed_tag, 1])
        else:
            processed_tag[1] += 1

for part in processed_tags:
    print(f"{part[0]} {part[1]}")
