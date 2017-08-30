#!/bin/bash
#
# Only prints the first element,
# which is why this is considered
# bad form among shell script authors.

apples=(red green wormy)

for apple in $apples
do
    echo "$apple"
done
