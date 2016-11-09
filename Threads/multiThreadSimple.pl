#!/usr/bin/perl

use strict;
use warnings;
use threads;

# Define the number of threads
my $num_of_threads = 2;
# use the initThreads subroutine to create an array of threads.
############## MAIN ###########################
my @threads;

# Loop through the array:
for (my $i = 0; $i < 5; $i++){
  push(@threads, threads->create(\&doSomething));
}

# This tells the main program to keep running until all threads have finished.
foreach(@threads){
    $_->join();
}

####################### SUBROUTINES ############################

sub doOperation{
    # Get the thread id. Allows each thread to be identified.
    my $id = threads->tid();
    my $i = 0;
    while($i < 100000000){
            $i++
    }
    print "Thread $id done!\n";
    # Exit the thread
    threads->exit();
}


sub doSomething() {

  my $id = threads->tid();
  my $ticket = int rand(1000000);

  print "Starting thread $id\n";
  for ( my $i = 0; $i < 1000000; $i++) {
    if ( $ticket == $i ) {
      print "finally won after play $i times\n";
    }
  }
  threads->exit();
  print "End thread $id\n"

}