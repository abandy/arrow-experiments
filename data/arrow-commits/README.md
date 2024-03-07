<!---
  Licensed to the Apache Software Foundation (ASF) under one
  or more contributor license agreements.  See the NOTICE file
  distributed with this work for additional information
  regarding copyright ownership.  The ASF licenses this file
  to you under the Apache License, Version 2.0 (the
  "License"); you may not use this file except in compliance
  with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing,
  software distributed under the License is distributed on an
  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
  KIND, either express or implied.  See the License for the
  specific language governing permissions and limitations
  under the License.
-->

# arrow-commits

Commits to the apache/arrow repository as of ~2024-03-06 as generated by
`git log`, interpreted by the [gert package for R](https://docs.ropensci.org/gert/),
and written by the [arrow package for R](https://arrow.apache.org/docs/r) as an uncompressed
[Arrow IPC Stream](https://arrow.apache.org/docs/format/Columnar.html#serialization-and-interprocess-communication-ipc).
For comparison and testing purposes, a line-delimited JSON version is also included.
The data contain 15,487 rows, 5 columns, and are approximiatly 2 MB in size.

Read in R:

```r
library(arrow, warn.conflicts = FALSE)
read_ipc_stream("data/arrow-commits/arrow-commits.arrows")
# # A tibble: 15,487 × 5
#    commit                                time                files merge message
#    <chr>                                 <dttm>              <int> <lgl> <chr>
#  1 49cdb0fe4e98fda19031c864a18e6156c6ed… 2024-03-07 02:00:52     2 FALSE GH-403…
#  2 1d966e98e41ce817d1f8c5159c0b9caa4de7… 2024-03-06 21:51:34     1 FALSE GH-403…
#  3 96f26a89bd73997f7532643cdb27d04b7097… 2024-03-06 20:29:15     1 FALSE GH-402…
#  4 ee1a8c39a55f3543a82fed900dadca791f6e… 2024-03-06 07:46:45     1 FALSE GH-403…
#  5 3d467ac7bfae03cf2db09807054c5672e195… 2024-03-05 16:13:32     1 FALSE GH-201…
#  6 ef6ea6beed071ed070daf03508f4c14b4072… 2024-03-05 14:53:13    20 FALSE GH-403…
#  7 53e0c745ad491af98a5bf18b67541b12d779… 2024-03-05 12:31:38     2 FALSE GH-401…
#  8 3ba6d286caad328b8572a3b9228045da8c8d… 2024-03-05 08:15:42     6 FALSE GH-400…
#  9 4ce9a5edd2710fb8bf0c642fd0e3863b01c2… 2024-03-05 07:56:25     2 FALSE GH-401…
# 10 2445975162905bd8d9a42ffc9cd0daa0e19d… 2024-03-05 01:04:20     1 FALSE GH-403…
# # ℹ 15,477 more rows
# # ℹ Use `print(n = ...)` to see more rows
```

Read in Python:

```python
from pyarrow import ipc

with ipc.open_stream("data/arrow-commits/arrow-commits.arrows") as stream:
    stream.read_all()

# pyarrow.Table
# commit: string
# time: timestamp[us, tz=UTC]
# files: int32
# merge: bool
# message: string
# ----
# commit: [["49cdb0fe4e98fda19031c864a18e6156c6edbf3c","1d966e98e41ce817d1f8c5159c
# time: [[2024-03-07 02:00:52.000000Z,2024-03-06 21:51:34.000000Z,2024-03-06 20:29
# files: [[2,1,1,1,1,...,1,8,2,2,4],[19,3,8,33,1,...,1,1,2,3,7],...,[7,21,2,3,6,..
# merge: [[false,false,false,false,false,...,false,false,false,false,false],[false
# message: [["GH-40370: [C++] Define ARROW_FORCE_INLINE for non-MSVC builds (#4037
```