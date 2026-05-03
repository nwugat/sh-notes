#!/usr/bin/env python

# Takes SORTED list of UNIQUE tags and outputs a tree view

#TODO: include occurrences
#TODO: hide root node

import sys

KEY_TEXT = "text"
KEY_CHILDREN = "children"

tags = sys.stdin.read().strip().split("\n")

tree_root = {
    KEY_TEXT: "ROOT",
    KEY_CHILDREN: [],
    }

# create tree structure
# too many nested loops :S
for tag in tags:
    tag_parts = tag.split("/")

    current_tree_node = tree_root
    for part in tag_parts:
        # is subtag i in under prev lvl tag?
        # ie make sure subtag exists in tree by making it if not found
        subtag_instances = list(filter(
            lambda child : part == child[KEY_TEXT],
            current_tree_node[KEY_CHILDREN]
        ))
        found_subtag = len(subtag_instances) >= 1
        if found_subtag:
            current_tree_node = next(iter(subtag_instances))
        else:
            # create subtag node
            next_tree_node = {
                KEY_TEXT: part,
                KEY_CHILDREN: [],
            }
            # add subtag below current node
            current_tree_node[KEY_CHILDREN].append(next_tree_node)
            # the subtag is now our current node, next cycle
            current_tree_node = next_tree_node

# print tree

# def print_tree_node_rec(node, is_last, level):
#     joint_graphic = "`- " if is_last else "+- "
#     # tab_lines = "|  " * level
#     last_tab_line = 
#     tab_lines = "|  " * (level - 1) + last_tab_line
#     print( tab_lines + joint_graphic+ node[KEY_TEXT])
#     child_count = len(node[KEY_CHILDREN])
#     if child_count >= 1:
#         for i in range(child_count):
#             print_tree_node_rec(node[KEY_CHILDREN][i], i == child_count - 1, level + 1)

# print_tree_node_rec(tree_root, len(tree_root[KEY_CHILDREN]) <= 1, 0)

def print_tree_node_rec(node, level):
    print("|   " * level + "+-- " + node[KEY_TEXT])
    if len(node[KEY_CHILDREN]) >= 1:
        for child in node[KEY_CHILDREN]:
            # print(child_count, " - ", i, " = ", child_count - i)
            print_tree_node_rec(child, level + 1)

print_tree_node_rec(tree_root, 0)

# It works! :)
