#!/usr/bin/env perl

# TASKS:
# * parse individual tags a/b/c/d/..., 1/2/3/4/..., etc. into trees
# * join trees into one big tree
# * print big tree

use constant TEXT_KEY => "text";
use constant CHILDREN_KEY => "children";

my %root_tree_node = (TEXT_KEY => "", CHILDREN_KEY => []);

print "I don't work yet :(\n";
exit;

# populate tree
while (<STDIN>) {
  my @tag_parts = split "/", $_;
  my $current_tree_node = \%root_tree_node;
  for (my $i=0; $i<=$#tag_parts; $i++) {# $i == level
    $current_tree_node->{TEXT_KEY} = $tag_parts[$i];
    push @{ $current_tree_node->{CHILDREN_KEY} //= [] }, {};

  }
}

# print tree
sub print_tree_recursive {
  my ($node, $level) = @_;
  #TODO
}
