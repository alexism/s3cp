# Copyright (C) 2010-2012 Alex Boisvert and Bizo Inc. / All rights reserved.
#
# Licensed to the Apache Software Foundation (ASF) under one or more contributor
# license agreements.  See the NOTICE file  distributed with this work for
# additional information regarding copyright ownership.  The ASF licenses this
# file to you under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License.  You may obtain a copy of
# the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.

require 'rubygems'
require 'extensions/kernel' if RUBY_VERSION =~ /1.8/
require 'right_aws'
require 'optparse'
require 's3cp/utils'

op = OptionParser.new do |opts|
  opts.banner = "s3stat [path]"

  opts.on_tail("-h", "--help", "Show this message") do
    puts op
    exit
  end
end

op.parse!(ARGV)

if ARGV.size < 1
  puts op
  exit
end

source  = ARGV[0]
permission = ARGV.last

@s3 = S3CP.connect()

def get_metadata(bucket, key)
  metadata = @s3.interface.head(bucket, key)
  metadata.sort.each do |k,v|
    puts "#{"%20s" % k} #{v}"
  end
end

bucket,key = S3CP.bucket_and_key(source)
get_metadata(bucket, key)
