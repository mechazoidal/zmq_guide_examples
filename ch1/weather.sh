#!/bin/bash

ruby wuserver.rb &
ruby wuclient.rb -z 12345 &
ruby wuclient.rb -z 23456 &
ruby wuclient.rb -z 34567 &
ruby wuclient.rb -z 45678 &
ruby wuclient.rb -z 56789 &

