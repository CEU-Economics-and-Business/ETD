#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Mar 20 19:34:11 2021

@author: zavecz
"""

import pandas as pd
import csv
from itertools import chain

with open("output/all.csv", newline = "") as f:
    reader = csv.reader(f)
    theses = list(reader)

links = [thesis[6] for thesis in theses][1:]
#print(links)

#theses = pd.read_csv("output/all.csv")
#links = theses["pdf_link"].tolist()
#print(links)

links_filtered = [link for link in links if "etd" in link]
row_file = ["theses/" + link.rsplit("/",1)[-1].lower().rstrip() for link in links_filtered]
row_first = [file + ":" for file in row_file]
row_second = ["\twget -N -O $@ " + "'" + link.rstrip() + "'" for link in links_filtered]

row = [list(r) for r in zip(row_first,row_second)]
body = list(chain.from_iterable(row))


row_file_all = " ".join(row_file)
body.insert(0,"all: $(objects)")
body.insert(0,"objects = {}".format(row_file_all))
row.insert(0,"MAKEFLAGS += -j8")

with open("Makefile","w") as f:
  f.write("\n".join(body))
