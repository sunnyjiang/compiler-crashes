#!/usr/bin/perl
use IPC::Run3;
use BSD::Resource;
setrlimit(RLIMIT_CPU, 60, 60);
setrlimit(RLIMIT_FSIZE, 1*1000*1000*1000, 1*1000*1000*1000);
setrlimit(RLIMIT_AS, 6*1000*1000*1000, 6*1000*1000*1000);
setrlimit(RLIMIT_VMEM, 6*1000*1000*1000, 6*1000*1000*1000);
system "/home/regehr/z/compiler-install/gcc-r116627-install/bin/g++ -o /dev/null -ftemplate-depth-128 -fstack-protector -O3 -Wno-inline -Wall -pthread -fvisibility=hidden -Winvalid-pch  -c small.cpp >/dev/null 2>&1";
exit (-1) unless ($? == 0);
my $str = <<EOF;
internal compiler error: Segmentation fault
EOF
chomp $str;
system "rm -f out.txt";
my $err;
my $cmd = "/home/regehr/z/compiler-install/gcc-r112895-install/bin/g++ small.cpp ";
IPC::Run3::run3 ($cmd, \undef, \$err, \$err);
my $idx = index($err,$str);
exit (-1) if ($idx == -1);
exit (0);