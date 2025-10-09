#!/bin/bash

# 获取有更改的 Swift 文件列表
files=$(git diff --name-only HEAD -- '*.swift')

# 对每个文件进行格式化
for file in $files
do
  swiftformat "$file"
done