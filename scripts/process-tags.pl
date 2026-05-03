#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long;

# flags

my $deep_flag = 0;# print all nested tags

GetOptions("deep" => \$deep_flag);

# shift removes and returns the first element from @ARGV, each cycle
while(my $file_path = shift @ARGV) {

  # open -> open FILE_HANDLE, MODE ('<' is read), FILE_PATH
  # die -> die MSG
  # $! -> system error msg
  open my $file_handle, '<', $file_path or die "Can't open file $file_path: $!";
  # set line separator to undef
  local $/ = undef;
  # get first line of the file
  # it gets assigned all the file since we just unset the line separator
  my $file_content = <$file_handle>;
  # reset line separator (just in case)
  local $/ = "\n";
  close $file_handle;

  # process YAML tags
    # match frontmatter block, the bit in parenthesis is stored in $1 now
    # uses /s flag for matching newlines with . bc YAML block spans to multiple lines
    # the regex could be more flexible, allowing spaces after --- and more than 3 -, but Obsidian doesn't allow that, so we follow
  if($file_content =~ /\A---\n(.*?)\n---\n/s) {
    my $yaml_str = $1;

    # extract list tags
      # (?:...) non-capturing group, groups match but it's not stored
    # while ($yaml_str =~ /^tags:[ \t]*\n((?:^[ \t]*-[ \t]*[^\n]*(?:\n|\z))+)/mg) {
    #     my $tags_block = $1;
    #     for my $extracted_tag (extract_list_tags($tags_block)) {
    #         process_tag($extracted_tag);
    #     }
    # }
    # for some ungodly reason, this works just fine, but the code above doesn't
    # perl ig
    if ($yaml_str =~ /^tags:[ \t]*\n((?:^[ \t]*-[^\n]*(?:\n|\z))+)/m) {
      # $1 is the tag block
      # $1 against this regex returns a list of tag strings
      # this list is passed to format_tag_array, which removes invalid tags
      my @tags = format_tag_array($1 =~ /^[ \t]*-[ \t]*([^\n]*)$/mg);
      process_tag($_) for @tags;
    }

    # extract inline list tags
    if ($yaml_str =~ /^tags:\s*\[(.*?)\]/m) {
      # my $tag_list_string = $1;
      # for my $extracted_tag (extract_inline_tags($tag_list_string)) {
      #     process_tag($extracted_tag);
      # }
      my @tags = format_tag_array(split /\s*,\s*/, $1);
    }
  }

  # process inline tags

  # discard YAML block
  $file_content =~ s/\A---.*?^---\s*\n//sm;

  # discard codeblocks
  # $file_content =~ s/^```[^\n]*\n.*?^```[ \t]*\n?//gms;
  $file_content =~ s/^```.*?^```//gms;

  # discard inline code
  $file_content =~ s/`.*?`//g;

  # discard angle bracket links
  $file_content =~ s/<.*?>//g;

  # discard links
  #TODO preserve [anchor display text]
  $file_content =~ s/\[[^\]]*\]\([^\)]*\)//g;

  # discard wikilinks
  $file_content =~ s/\[\[.*?\]\]//g;

  # extract tags
  # match strings with leading #, ending at a delimiter (Obsidian)
  for my $tag ($file_content =~ /#[^#\s.,!?:;"'\(\)\[\]{}]+/g) {
    process_tag($tag =~ s/^#//r);
  }
}

# Subroutines

# print nested tags
sub process_tag {
  my ($tag) = @_;
  if ($deep_flag) {
    # remove trailing slash
    # my @parts = grep { $_ ne "" } split "/", $tag;
    my @parts = grep { $_ !~ /^\s*$/ } split "/", $tag;#TODO why doesn't this work
    my $acc = ""; #accumulator
    for my $part (@parts) {
      $acc = $acc eq "" ? $part : "$acc/$part";
      print "$acc\n";
    }
  }
  else {
    print "$tag\n";
  }
}

# remove invalid tags, format valid tags
sub format_tag_array {
  my (@tags) = @_;
  return
    # grep { !/[#"']/ }# no internal # " or '
    grep { !/[\s#.,!?:;"'\(\)\[\]{}]/ }     # no internal delimiters
    #TODO keep this?
    # map { s/^#//r }# remove leading #
    map { s/^\s*["']\s*+|\s*["']+\s*$//gr } # remove surrounding quotes
    # grep { !/\s/ }# no internal whitespaces
    map { s/^\s+|\s+$//r }                  # trim whitespaces
    grep { /\S/ } @tags;                    # non-empty
}

#TODO remove
# for YAML multiline list
sub extract_list_tags {
  my ($tags_block) = @_;
  $tags_block  =~ s/^\s+-//gm;
  #TODO remove
  # my @result;
  # /g finds all matches
  # each time the regex is run, perl moves a hidden pointer and overwrites $1
  # while ($tags_block =~ /^\s*-\s*(.+)$/mg) {
  #   push @result, "$1\n";
  # }
  return
    format_tag_array
    split /\s*\n\s*/, $tags_block;
}

#TODO remove
# for YAML inline list
sub extract_inline_tags {
  my ($string) = @_;
  # grep returns the subset of a list where each item fulfills the condition in braces
  # map takes an expression and applies it to every element in an array
  return
    format_tag_array
    split /\s*,\s*/, $string;
}
