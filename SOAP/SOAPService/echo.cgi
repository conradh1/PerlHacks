#!/usr/bin/perl -w
# Filename: echo.cgi
# Echo Web Service - This Web service will echo any input and return
# it in its response.
# Author: Byrne Reese
use Echo;
use SOAP::Transport::HTTP;
SOAP::Transport::HTTP::CGI
->dispatch_to('Echo')
->handle;