#!/bin/bash
set -ue

prefix=`basename $0`
timestamp_file=/tmp/$prefix.timestamp
cache_file=/tmp/$prefix.cache
timestamp=`date '+%s'`
cache_time=300

describe_images(){
    echo $timestamp > $timestamp_file
    aws ec2 describe-images \
        --owners self amazon \
        --filters \
          Name=virtualization-type,Values=hvm \
          Name=root-device-type,Values=ebs \
          Name=architecture,Values=x86_64 \
          Name=block-device-mapping.volume-type,Values=standard
}

# 出力を括弧でまとめる
(
if [ -e $timestamp_file ];then
    cache_timestamp=`cat $timestamp_file`
----
    # キャッシュファイルが有効期間を過ぎている場合はAWSから読み出してキャッシュファイルにも書く
    if [ $timestamp -gt `expr $cache_timestamp + $cache_time` ];then
        describe_images | tee $cache_file
    else
    # キャッシュファイルが有効期間内の場合はキャッシュファイルを読み出すだけ
        cat $cache_file
    fi
# キャッシュファイルがない場合
else
    describe_images | tee $cache_file
fi
) | jq -r '.Images | sort_by(.Name)| .[] | select(.Platform != "windows") | .Name + ": " + .ImageId'
