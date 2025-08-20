#!/usr/bin/perl
# Simple test CGI to verify basic functionality

print "Content-Type: text/html\n\n";
print "<html><head><title>NetRun Test</title></head><body>";
print "<h1>NetRun Test Page</h1>";
print "<p>If you can see this, the basic CGI is working.</p>";
print "<p>Environment variables:</p><ul>";

foreach my $key (sort keys %ENV) {
    print "<li>$key = $ENV{$key}</li>";
}

print "</ul>";
print "<p>Current directory: " . `pwd` . "</p>";
print "<p>Perl version: $]</p>";
print "</body></html>";