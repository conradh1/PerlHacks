#!/usr/bin/perl -w

use CGI;

$upload_dir = "/var/www/cgi-bin/test";
               
$query = new CGI;

print $query->header().
      $query->start_html(-title=>"Upload File",-bgcolor=>"#DDDDDD");
 
if ($query->param("submit"))
{
  $filename = $query->param("photo");
  $email_address = $query->param("email_address");
  #$filename =~ s/.*[\/\\](.*)/$1/;
  $upload_filehandle = $query->upload("photo");
 
  open UPLOADFILE, ">$upload_dir/$filename";

  binmode UPLOADFILE;

  while ( <$upload_filehandle> )
  {
     print UPLOADFILE;
  }

  close UPLOADFILE;

  print $query->h3("File Uploaded!").
        $query->img( {-src=>"test/$filename" }).
        $query->p("Your email address is $email_address").
        $query->p("The name of your file is $filename ");

}
else {
  print $query->h3("Upload Form").
        $query->startform( -name=>"fileform", -method=>"post", -enctype=>"multipart/form-data").
        "Photo to Upload: <INPUT TYPE=\"file\" NAME=\"photo\"> ".
        $query->br().
        "Your Email Address: ".$query->textfield( -name=>"email_address", -value=>"").$query->br().
        $query->submit( -name=>"submit", -value=>"Submit Form").
        $query->endform();
        
}


  $query->end_html();
