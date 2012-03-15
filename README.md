
This project is a proof of concept designed to confirm the viability of accessing [PostreSQL][1] from [Goliath][2], in a non-blocking fashion.


### Goals Met:

1. Make sure that blocking database operations, like "select pg_sleep(1)", don't interfere with our ability to accept and respond to http requests.

1. Limit, without blocking, the number of database connections we're holding open.

1. Don't crash in a giant ball of fire under minor load.


### Running the demo server

1. Make sure you have postgres running locally

1. Make sure you have ruby 1.9.x and bundler installed

1. Clone the project, bundle, etc.

1. Launch the server
   `$ ./api --port=9000 --verbose`
   `[75693:INFO] 2012-03-15 15:23:06 :: Starting server on 0.0.0.0:9000 in development mode. Watch out for stones`

1. Confirm it's basically working
   `$ time curl -i localhost:9000`
   `HTTP/1.1 200 OK`
   `Content-Type: text/plain`
   `Content-Length: 8`
   `Server: Goliath`
   `Date: Thu, 15 Mar 2012 21:28:12 GMT`
   
   `pg_sleep`
   `real    0m1.025s`
   `user    0m0.002s`
   `sys     0m0.003s`



### Resources:

- [PostgreSQL][1]

- [Goliath][2] -- Rubyists should really spend more time with this project.

- [EM::Synchrony][3] -- Because it makes node.js kids jealous.

- [EM::Postgres][4] -- I was especially glad to run into this project, as it's exactly 
what I was expecting to have to implement on my own.

- [OldMoe][5] -- Dated, but very interesting work on non-blocking database IO. Really highlights the fundamental reasons for pursuing this architecture.

- [StackOverflow][6] -- Because I had the same basic question.


[1]: http://www.postgresql.org
[2]: http://postrank-labs.github.com/goliath
[3]: https://github.com/igrigorik/em-synchrony
[4]: https://github.com/jtoy/em-postgres
[5]: http://oldmoe.blogspot.com/2008/07/faster-io-for-ruby-with-postgres.html
[6]: http://stackoverflow.com/questions/5893524/using-the-postgresql-gem-async



### Results


    #----------------------------------------------------------------------
    $ ab -d -S -n30 -c5 http://localhost:9000/
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient).....done


    Server Software:        Goliath
    Server Hostname:        localhost
    Server Port:            9000

    Document Path:          /
    Document Length:        8 bytes

    Concurrency Level:      5
    Time taken for tests:   6.045 seconds
    Complete requests:      30
    Failed requests:        0
    Write errors:           0
    Total transferred:      3780 bytes
    HTML transferred:       240 bytes
    Requests per second:    4.96 [#/sec] (mean)
    Time per request:       1007.507 [ms] (mean)
    Time per request:       201.501 [ms] (mean, across all concurrent requests)
    Transfer rate:          0.61 [Kbytes/sec] received

    Connection Times (ms)
                  min   avg   max
    Connect:        0     0    0
    Processing:  1003  1006 1015
    Total:       1003  1006 1015

    #----------------------------------------------------------------------
    $ ab -d -S -n30 -c10 http://localhost:9000/
    This is ApacheBench, Version 2.3 <$Revision: 655654 $>
    Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
    Licensed to The Apache Software Foundation, http://www.apache.org/

    Benchmarking localhost (be patient).....done


    Server Software:        Goliath
    Server Hostname:        localhost
    Server Port:            9000

    Document Path:          /
    Document Length:        8 bytes

    Concurrency Level:      10
    Time taken for tests:   6.022 seconds
    Complete requests:      30
    Failed requests:        0
    Write errors:           0
    Total transferred:      3780 bytes
    HTML transferred:       240 bytes
    Requests per second:    4.98 [#/sec] (mean)
    Time per request:       2007.397 [ms] (mean)
    Time per request:       200.740 [ms] (mean, across all concurrent requests)
    Transfer rate:          0.61 [Kbytes/sec] received

    Connection Times (ms)
                  min   avg   max
    Connect:        0     0    0
    Processing:  1004  1838 2020
    Total:       1004  1838 2020
